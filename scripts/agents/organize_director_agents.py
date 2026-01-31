#!/usr/bin/env python3
"""Organize all Director agents into their domain folders."""

import shutil
from pathlib import Path
import json

def organize_directors():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    # Director to domain mapping
    director_mapping = {
        "analytics_director_agent.json": "analytics",
        "creative_director_agent.json": "marketing",  # Creative reports to Marketing
        "customer_experience_director_agent.json": "customer_experience",
        "finance_director_agent.json": "finance",
        "operations_director_agent.json": "operations",
        "product_director_agent.json": "product",
        "social_media_director_agent.json": "social_media",
        "technology_director_agent.json": "technology",
        "Social Media Director Agent (2).json": "social_media"  # Use the better version
    }
    
    print("Organizing Director Agents")
    print("=" * 60)
    
    moved_count = 0
    
    # We already have these organized:
    # - Business Manager (in core/orchestration)
    # - Marketing Director (in domains/marketing)
    # - Sales Director (in domains/sales)
    
    print("Already organized:")
    print("  ✓ Business Manager Agent (core/orchestration)")
    print("  ✓ Marketing Director Agent (domains/marketing)")
    print("  ✓ Sales Director Agent (domains/sales)")
    
    print("\nOrganizing remaining directors:")
    
    for filename, domain in director_mapping.items():
        source = base_dir / filename
        
        if source.exists():
            # Special handling for Social Media Director
            if filename == "Social Media Director Agent (2).json":
                # Rename to proper name
                target_name = "social_media_director_agent.json"
                # Archive the other version
                old_version = base_dir / "social_media_director_agent.json"
                if old_version.exists():
                    archive_dir = base_dir / "workflows" / "archive" / "social_media_versions"
                    archive_dir.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(old_version), str(archive_dir / old_version.name))
                    print(f"  → Archived older version: social_media_director_agent.json")
            else:
                target_name = filename
            
            target_dir = base_dir / "workflows" / "domains" / domain
            target_dir.mkdir(parents=True, exist_ok=True)
            
            dest = target_dir / target_name
            shutil.move(str(source), str(dest))
            
            print(f"  ✓ {filename} → domains/{domain}/{target_name}")
            moved_count += 1
        else:
            print(f"  ✗ Not found: {filename}")
    
    # Check what directors we have now
    print("\n" + "=" * 60)
    print("Director Coverage Summary:")
    
    expected_directors = [
        "Business Manager", "Marketing", "Sales", "Analytics", 
        "Finance", "Operations", "Customer Experience", 
        "Product", "Technology", "Social Media"
    ]
    
    found_directors = []
    
    # Check core for Business Manager
    if (base_dir / "workflows/core/orchestration/business_manager_agent.json").exists():
        found_directors.append("Business Manager")
    
    # Check domains for other directors
    domains_dir = base_dir / "workflows" / "domains"
    for domain_dir in domains_dir.iterdir():
        if domain_dir.is_dir():
            for file in domain_dir.glob("*director*.json"):
                # Extract director type from filename
                if "marketing" in str(file):
                    found_directors.append("Marketing")
                elif "sales" in str(file):
                    found_directors.append("Sales")
                elif "analytics" in str(file):
                    found_directors.append("Analytics")
                elif "finance" in str(file):
                    found_directors.append("Finance")
                elif "operations" in str(file):
                    found_directors.append("Operations")
                elif "customer_experience" in str(file):
                    found_directors.append("Customer Experience")
                elif "product" in str(file):
                    found_directors.append("Product")
                elif "technology" in str(file):
                    found_directors.append("Technology")
                elif "social_media" in str(file):
                    found_directors.append("Social Media")
    
    found_directors = list(set(found_directors))  # Remove duplicates
    
    print(f"\nFound {len(found_directors)}/{len(expected_directors)} directors:")
    for director in sorted(found_directors):
        print(f"  ✓ {director} Director")
    
    missing = set(expected_directors) - set(found_directors)
    if missing:
        print(f"\nMissing directors:")
        for director in sorted(missing):
            print(f"  ✗ {director} Director")
    
    print(f"\n✓ Organized {moved_count} director agents")
    
    # Also note that Creative Director reports to Marketing
    if "creative_director_agent.json" in [f.name for f in (base_dir / "workflows/domains/marketing").glob("*.json")]:
        print("\nNote: Creative Director placed under Marketing domain (reports to Marketing Director)")

if __name__ == "__main__":
    organize_directors()