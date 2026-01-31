#!/usr/bin/env python3
"""
Build Domain Ontologies for VividWalls MAS Agents.
Implements the ontology construction approach from instructions.md,
focusing on extracting core domain concepts, taxonomies, and relationships.
"""

import os
import json
import requests
import openai
import base64
import time
from typing import List, Dict, Any, Optional, Set, Tuple
from pathlib import Path
from urllib.parse import urlparse, urljoin
import re
import sys
from collections import defaultdict
import concurrent.futures

# Add current directory to import domain sources
sys.path.append(str(Path(__file__).parent))
from domain_authority_sources import DOMAIN_AUTHORITY_SOURCES, ONTOLOGY_RESOURCES, RAG_CONFIGURATIONS

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJiYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Neo4j for knowledge graph
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Headers for Supabase
AUTH_STRING = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
SUPABASE_HEADERS = {
    "Authorization": f"Basic {AUTH_STRING}",
    "apikey": SUPABASE_SERVICE_KEY,
    "Content-Type": "application/json"
}

class OntologyBuilder:
    """Build domain ontologies from authoritative sources."""
    
    def __init__(self):
        self.concepts = defaultdict(set)  # domain -> set of concepts
        self.relationships = defaultdict(list)  # domain -> list of (subject, predicate, object)
        self.hierarchies = defaultdict(dict)  # domain -> concept -> parent concept
        self.properties = defaultdict(dict)  # domain -> concept -> properties
        
    def extract_glossary_terms(self, url: str, domain: str) -> List[Dict[str, Any]]:
        """Extract terms from glossary or dictionary pages."""
        try:
            # Crawl the glossary page
            request_data = {
                "url": url,
                "wait_for": "networkidle",
                "screenshot": False,
                "remove_overlay": True,
                "bypass_cache": True
            }
            
            response = requests.post(
                f"{CRAWL4AI_URL}/crawl",
                json=request_data,
                headers={"Content-Type": "application/json"},
                timeout=60
            )
            
            if response.status_code != 200:
                print(f"Failed to crawl {url}")
                return []
            
            result = response.json()
            content = result.get("markdown") or result.get("content") or ""
            
            # Extract terms and definitions
            terms = self.parse_glossary_content(content, domain)
            return terms
            
        except Exception as e:
            print(f"Error extracting glossary from {url}: {e}")
            return []
    
    def parse_glossary_content(self, content: str, domain: str) -> List[Dict[str, Any]]:
        """Parse glossary content to extract terms and definitions."""
        terms = []
        
        # Pattern matching for common glossary formats
        patterns = [
            # Definition lists: **Term**: Definition
            r'\*\*([^*]+)\*\*:\s*([^*\n]+)',
            # Heading followed by definition
            r'#{1,3}\s*([^\n]+)\n+([^#\n][^\n]+)',
            # Term - Definition format
            r'^([A-Z][^-\n]+)\s*-\s*([^-\n]+)',
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content, re.MULTILINE)
            for match in matches:
                term = match[0].strip()
                definition = match[1].strip()
                
                if len(term) < 50 and len(definition) > 20:  # Filter noise
                    terms.append({
                        'term': term,
                        'definition': definition,
                        'domain': domain,
                        'source': 'glossary'
                    })
                    
                    # Add to concepts
                    self.concepts[domain].add(term)
        
        return terms
    
    def extract_schema_org_concepts(self, schema_type: str, domain: str) -> Dict[str, Any]:
        """Extract concepts from schema.org definitions."""
        schema_url = f"https://schema.org/{schema_type}"
        
        try:
            # Crawl schema.org page
            request_data = {
                "url": schema_url,
                "wait_for": "networkidle",
                "screenshot": False
            }
            
            response = requests.post(
                f"{CRAWL4AI_URL}/crawl",
                json=request_data,
                headers={"Content-Type": "application/json"},
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                content = result.get("content", "")
                
                # Extract properties and relationships
                properties = self.parse_schema_properties(content, schema_type)
                
                # Add to domain concepts
                self.concepts[domain].add(schema_type)
                self.properties[domain][schema_type] = properties
                
                return {
                    'type': schema_type,
                    'properties': properties,
                    'domain': domain
                }
                
        except Exception as e:
            print(f"Error extracting schema.org {schema_type}: {e}")
            
        return {}
    
    def parse_schema_properties(self, content: str, schema_type: str) -> List[Dict[str, str]]:
        """Parse schema.org properties from content."""
        properties = []
        
        # Extract property definitions
        property_pattern = r'property:\s*([a-zA-Z]+).*?(?:expected type|range):\s*([^,\n]+)'
        matches = re.findall(property_pattern, content, re.IGNORECASE | re.DOTALL)
        
        for prop_name, prop_type in matches:
            properties.append({
                'name': prop_name.strip(),
                'type': prop_type.strip(),
                'schema_type': schema_type
            })
        
        return properties
    
    def build_concept_hierarchy(self, domain: str, concepts: Set[str]) -> Dict[str, str]:
        """Build hierarchical relationships between concepts using LLM."""
        if not concepts:
            return {}
            
        hierarchy = {}
        concept_list = list(concepts)[:20]  # Limit for API
        
        try:
            prompt = f"""Given these {domain} domain concepts, identify parent-child relationships:
Concepts: {', '.join(concept_list)}

For each concept that has a clear parent concept from the list, provide the relationship in format:
child_concept -> parent_concept

Only include clear hierarchical relationships."""

            response = openai.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are an ontology expert identifying concept hierarchies."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.3,
                max_tokens=300
            )
            
            # Parse relationships
            relationships = response.choices[0].message.content.strip()
            for line in relationships.split('\n'):
                if '->' in line:
                    child, parent = line.split('->')
                    child = child.strip()
                    parent = parent.strip()
                    if child in concepts and parent in concepts:
                        hierarchy[child] = parent
                        self.relationships[domain].append((child, "subClassOf", parent))
                        
        except Exception as e:
            print(f"Error building hierarchy for {domain}: {e}")
            
        return hierarchy
    
    def extract_relationships(self, domain: str, content: str) -> List[Tuple[str, str, str]]:
        """Extract semantic relationships from content."""
        relationships = []
        
        # Common relationship patterns
        patterns = [
            # X is a type of Y
            (r'([A-Za-z\s]+) is a (?:type|kind) of ([A-Za-z\s]+)', 'subClassOf'),
            # X includes/contains Y
            (r'([A-Za-z\s]+) (?:includes|contains) ([A-Za-z\s]+)', 'hasPart'),
            # X uses Y
            (r'([A-Za-z\s]+) uses ([A-Za-z\s]+)', 'uses'),
            # X measures Y
            (r'([A-Za-z\s]+) measures ([A-Za-z\s]+)', 'measures'),
            # X targets Y
            (r'([A-Za-z\s]+) targets ([A-Za-z\s]+)', 'targets')
        ]
        
        for pattern, relation_type in patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                subject = match[0].strip()
                object = match[1].strip()
                
                # Validate concepts exist in domain
                if subject in self.concepts[domain] or object in self.concepts[domain]:
                    relationships.append((subject, relation_type, object))
                    self.relationships[domain].append((subject, relation_type, object))
        
        return relationships
    
    def store_ontology_in_neo4j(self, domain: str):
        """Store ontology in Neo4j knowledge graph."""
        try:
            from neo4j import GraphDatabase
            
            driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
            
            with driver.session() as session:
                # Create domain node
                session.run("""
                    MERGE (d:Domain {name: $domain})
                    SET d.updated_at = datetime()
                """, domain=domain)
                
                # Create concept nodes
                for concept in self.concepts[domain]:
                    properties = self.properties[domain].get(concept, {})
                    session.run("""
                        MATCH (d:Domain {name: $domain})
                        MERGE (c:Concept {name: $concept, domain: $domain})
                        SET c.properties = $properties,
                            c.created_at = datetime()
                        MERGE (c)-[:BELONGS_TO]->(d)
                    """, domain=domain, concept=concept, properties=json.dumps(properties))
                
                # Create relationships
                for subject, predicate, object in self.relationships[domain]:
                    session.run(f"""
                        MATCH (s:Concept {{name: $subject, domain: $domain}})
                        MATCH (o:Concept {{name: $object, domain: $domain}})
                        MERGE (s)-[:{predicate}]->(o)
                    """, subject=subject, object=object, domain=domain, predicate=predicate)
                
                print(f"✓ Stored {len(self.concepts[domain])} concepts and {len(self.relationships[domain])} relationships for {domain}")
                
            driver.close()
            
        except Exception as e:
            print(f"Error storing ontology in Neo4j: {e}")
    
    def store_ontology_in_supabase(self, domain: str, agent_id: str):
        """Store ontology concepts as embeddings in Supabase."""
        if not self.concepts[domain]:
            return
            
        print(f"Storing {len(self.concepts[domain])} concepts for {agent_id}...")
        
        # Prepare records
        records = []
        for concept in self.concepts[domain]:
            # Create concept description
            properties = self.properties[domain].get(concept, {})
            hierarchy = self.hierarchies[domain].get(concept, "")
            
            content = f"Concept: {concept}\nDomain: {domain}"
            if hierarchy:
                content += f"\nParent: {hierarchy}"
            if properties:
                content += f"\nProperties: {json.dumps(properties)}"
            
            # Generate embedding
            try:
                response = openai.embeddings.create(
                    model="text-embedding-3-small",
                    input=content
                )
                embedding = response.data[0].embedding
                
                record = {
                    "agent_id": agent_id,
                    "collection": f"{agent_id}_ontology",
                    "content": content,
                    "metadata": {
                        "concept": concept,
                        "domain": domain,
                        "content_type": "ontology",
                        "has_hierarchy": bool(hierarchy),
                        "property_count": len(properties)
                    },
                    "embedding": embedding
                }
                records.append(record)
                
            except Exception as e:
                print(f"Error creating embedding for {concept}: {e}")
        
        # Store in batches
        batch_size = 20
        for i in range(0, len(records), batch_size):
            batch = records[i:i+batch_size]
            
            try:
                response = requests.post(
                    f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                    json=batch,
                    headers=SUPABASE_HEADERS,
                    timeout=30
                )
                
                if response.status_code in [200, 201]:
                    print(f"  ✓ Stored batch {i//batch_size + 1}")
                else:
                    print(f"  ✗ Failed batch: {response.status_code}")
                    
            except Exception as e:
                print(f"  ✗ Error storing batch: {e}")

def build_domain_ontology(agent_id: str, domain_config: Dict[str, Any]):
    """Build ontology for a specific agent domain."""
    print(f"\n{'='*60}")
    print(f"Building Ontology for {agent_id}")
    print(f"{'='*60}")
    
    builder = OntologyBuilder()
    domain = agent_id.replace("_director", "").replace("_agent", "")
    
    # 1. Extract from ontology sources
    ontology_sources = domain_config.get("ontology_sources", [])
    for source in ontology_sources:
        print(f"  Extracting from: {source}")
        if "dictionary" in source.lower() or "glossary" in source.lower():
            terms = builder.extract_glossary_terms(source, domain)
            print(f"    Found {len(terms)} terms")
        elif "schema.org" in source:
            # Extract schema type from URL
            schema_type = source.split("/")[-1]
            schema_data = builder.extract_schema_org_concepts(schema_type, domain)
            if schema_data:
                print(f"    Extracted schema: {schema_type}")
    
    # 2. Extract from primary sources
    primary_sources = domain_config.get("sources", [])[:3]  # Limit to avoid overload
    for source in primary_sources:
        print(f"  Analyzing: {source}")
        try:
            # Crawl source
            response = requests.post(
                f"{CRAWL4AI_URL}/crawl",
                json={"url": source, "wait_for": "networkidle"},
                headers={"Content-Type": "application/json"},
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                content = result.get("content", "")
                
                # Extract relationships
                relationships = builder.extract_relationships(domain, content[:5000])
                print(f"    Found {len(relationships)} relationships")
                
        except Exception as e:
            print(f"    Error: {e}")
    
    # 3. Build concept hierarchy
    if builder.concepts[domain]:
        print(f"\nBuilding concept hierarchy for {len(builder.concepts[domain])} concepts...")
        hierarchy = builder.build_concept_hierarchy(domain, builder.concepts[domain])
        builder.hierarchies[domain] = hierarchy
        print(f"  Created {len(hierarchy)} hierarchical relationships")
    
    # 4. Store in databases
    print("\nStoring ontology...")
    builder.store_ontology_in_neo4j(domain)
    builder.store_ontology_in_supabase(domain, agent_id)
    
    return {
        "concepts": len(builder.concepts[domain]),
        "relationships": len(builder.relationships[domain]),
        "hierarchies": len(builder.hierarchies[domain])
    }

def create_ontology_schema():
    """Create database schema for ontology storage."""
    schema_sql = """
-- Create ontology-specific tables
CREATE TABLE IF NOT EXISTS domain_ontologies (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    domain VARCHAR(100) NOT NULL,
    agent_id VARCHAR(255) NOT NULL,
    concept_count INTEGER DEFAULT 0,
    relationship_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(domain, agent_id)
);

-- Create ontology concepts table
CREATE TABLE IF NOT EXISTS ontology_concepts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    domain VARCHAR(100) NOT NULL,
    concept VARCHAR(255) NOT NULL,
    definition TEXT,
    parent_concept VARCHAR(255),
    properties JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(domain, concept)
);

-- Create ontology relationships table
CREATE TABLE IF NOT EXISTS ontology_relationships (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    domain VARCHAR(100) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    predicate VARCHAR(100) NOT NULL,
    object VARCHAR(255) NOT NULL,
    confidence FLOAT DEFAULT 1.0,
    source VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ontology_domain ON ontology_concepts(domain);
CREATE INDEX IF NOT EXISTS idx_ontology_concept ON ontology_concepts(concept);
CREATE INDEX IF NOT EXISTS idx_ontology_rel_domain ON ontology_relationships(domain);
CREATE INDEX IF NOT EXISTS idx_ontology_rel_subject ON ontology_relationships(subject);
CREATE INDEX IF NOT EXISTS idx_ontology_rel_object ON ontology_relationships(object);
"""
    
    print("Execute this SQL in Supabase to create ontology tables")
    return schema_sql

def main():
    """Build ontologies for all agents."""
    print("""
╔══════════════════════════════════════════════════════════════════════╗
║               DOMAIN ONTOLOGY BUILDER FOR VIVIDWALLS MAS             ║
║           Extracting Core Concepts, Taxonomies & Relationships       ║
╚══════════════════════════════════════════════════════════════════════╝
""")
    
    # Configure RAG for ontology building
    rag_config = RAG_CONFIGURATIONS["ontology_building"]
    print("\nRAG Configuration for Ontology Building:")
    for key, value in rag_config.items():
        print(f"  {key}={value}")
    
    # Create schema
    schema_sql = create_ontology_schema()
    with open("ontology_schema.sql", "w") as f:
        f.write(schema_sql)
    print(f"\nSchema saved to: ontology_schema.sql")
    
    # Priority agents for ontology building
    priority_agents = [
        "marketing_director",
        "sales_director",
        "product_director",
        "analytics_director"
    ]
    
    results = {}
    
    for agent_id in priority_agents:
        if agent_id in DOMAIN_AUTHORITY_SOURCES:
            config = DOMAIN_AUTHORITY_SOURCES[agent_id]
            if "ontology_sources" in config or "sources" in config:
                result = build_domain_ontology(agent_id, config)
                results[agent_id] = result
                time.sleep(5)  # Rate limiting
    
    # Summary
    print("\n" + "="*70)
    print("ONTOLOGY BUILDING COMPLETE")
    print("="*70)
    
    for agent, stats in results.items():
        print(f"\n{agent}:")
        print(f"  Concepts: {stats['concepts']}")
        print(f"  Relationships: {stats['relationships']}")
        print(f"  Hierarchies: {stats['hierarchies']}")
    
    print("\nNext steps:")
    print("1. Query Neo4j for ontology visualization:")
    print("   MATCH (c:Concept)-[r]->(c2:Concept) WHERE c.domain='marketing' RETURN c, r, c2")
    print("2. Use ontologies in agent reasoning:")
    print("   - Concept expansion for queries")
    print("   - Relationship inference")
    print("   - Domain-specific reasoning")

if __name__ == "__main__":
    main()