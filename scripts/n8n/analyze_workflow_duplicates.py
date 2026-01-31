#!/usr/bin/env python3
"""
N8N Workflow Duplicate Analysis and Resolution Script
Analyzes duplicate workflows and provides resolution recommendations
"""

import json
import os
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from collections import defaultdict
import difflib
import hashlib

class DuplicateAnalyzer:
    def __init__(self, inventory_file: str):
        self.inventory_file = inventory_file
        self.workflows = []
        self.duplicate_groups = []
        
    def load_inventory(self):
        """Load the workflow inventory from Task 1"""
        with open(self.inventory_file, 'r') as f:
            data = json.load(f)
            self.workflows = data['workflow_inventory']['workflows']
            
    def analyze_duplicates(self) -> Dict[str, Any]:
        """Perform comprehensive duplicate analysis"""
        # Find exact duplicates (from inventory)
        exact_duplicates = self._find_exact_duplicates()
        
        # Find functional duplicates
        functional_duplicates = self._find_functional_duplicates()
        
        # Find version variants
        version_variants = self._find_version_variants()
        
        # Combine all duplicate groups
        all_groups = []
        all_groups.extend(self._process_duplicate_group(g, 'exact') for g in exact_duplicates)
        all_groups.extend(self._process_duplicate_group(g, 'functional') for g in functional_duplicates)
        all_groups.extend(self._process_duplicate_group(g, 'version') for g in version_variants)
        
        # Generate removal impact analysis
        removal_impact = self._analyze_removal_impact(all_groups)
        
        return {
            'duplicate_analysis': {
                'summary': {
                    'duplicate_groups': len(all_groups),
                    'workflows_to_remove': sum(len(g['recommendation']['remove']) for g in all_groups),
                    'merge_candidates': sum(1 for g in all_groups if g['recommendation'].get('merge_features'))
                },
                'duplicate_groups': all_groups,
                'removal_impact': removal_impact
            }
        }
        
    def _find_exact_duplicates(self) -> List[List[Dict]]:
        """Find workflows with identical fingerprints"""
        fingerprint_map = defaultdict(list)
        
        for workflow in self.workflows:
            if workflow['validation_status'] == 'valid' and 'fingerprint' in workflow:
                fingerprint_map[workflow['fingerprint']].append(workflow)
                
        return [workflows for workflows in fingerprint_map.values() if len(workflows) > 1]
        
    def _find_functional_duplicates(self) -> List[List[Dict]]:
        """Find workflows with similar purpose but different implementation"""
        groups = []
        processed = set()
        
        # Group by similar names
        name_groups = defaultdict(list)
        for workflow in self.workflows:
            if workflow['validation_status'] == 'valid':
                # Normalize name for comparison
                base_name = self._normalize_name(workflow['name'])
                name_groups[base_name].append(workflow)
                
        # Check each group for functional similarity
        for base_name, workflows in name_groups.items():
            if len(workflows) > 1:
                # Further analyze if they're truly functional duplicates
                similar_groups = self._group_by_functionality(workflows)
                groups.extend(similar_groups)
                
        return groups
        
    def _find_version_variants(self) -> List[List[Dict]]:
        """Find workflows that are versions of the same base workflow"""
        version_patterns = ['_v', '_updated', '_new', '_enhanced', '_mcp', '(1)', '(2)']
        groups = []
        processed = set()
        
        for workflow in self.workflows:
            if workflow['file_path'] in processed or workflow['validation_status'] != 'valid':
                continue
                
            # Find potential versions
            base_name = self._extract_base_name(workflow['file_name'])
            versions = []
            
            for other in self.workflows:
                if other['file_path'] == workflow['file_path'] or other['validation_status'] != 'valid':
                    continue
                    
                other_base = self._extract_base_name(other['file_name'])
                
                # Check if it's a version variant
                if base_name == other_base or self._is_version_variant(workflow['file_name'], other['file_name']):
                    versions.append(other)
                    processed.add(other['file_path'])
                    
            if versions:
                versions.append(workflow)
                processed.add(workflow['file_path'])
                groups.append(versions)
                
        return groups
        
    def _normalize_name(self, name: str) -> str:
        """Normalize workflow name for comparison"""
        # Remove common suffixes and clean up
        name = name.lower()
        name = name.replace('_', ' ').replace('-', ' ')
        
        # Remove version indicators
        for pattern in ['updated', 'new', 'enhanced', 'v1', 'v2', '(1)', '(2)', 'mcp']:
            name = name.replace(pattern, '')
            
        return ' '.join(name.split()).strip()
        
    def _extract_base_name(self, filename: str) -> str:
        """Extract base name from filename"""
        name = filename.replace('.json', '')
        
        # Remove version patterns
        patterns = ['_updated', '_enhanced', '_new', '_v\\d+', '_mcp.*', '\\s*\\(\\d+\\)']
        for pattern in patterns:
            import re
            name = re.sub(pattern, '', name)
            
        return name.strip()
        
    def _is_version_variant(self, name1: str, name2: str) -> bool:
        """Check if two names are version variants"""
        base1 = self._extract_base_name(name1)
        base2 = self._extract_base_name(name2)
        
        # Check exact match after normalization
        if base1 == base2:
            return True
            
        # Check similarity ratio
        ratio = difflib.SequenceMatcher(None, base1, base2).ratio()
        return ratio > 0.8
        
    def _group_by_functionality(self, workflows: List[Dict]) -> List[List[Dict]]:
        """Group workflows by functional similarity"""
        groups = []
        processed = set()
        
        for i, workflow in enumerate(workflows):
            if workflow['file_path'] in processed:
                continue
                
            group = [workflow]
            processed.add(workflow['file_path'])
            
            for j, other in enumerate(workflows[i+1:], i+1):
                if other['file_path'] in processed:
                    continue
                    
                # Compare functionality
                if self._are_functionally_similar(workflow, other):
                    group.append(other)
                    processed.add(other['file_path'])
                    
            if len(group) > 1:
                groups.append(group)
                
        return groups
        
    def _are_functionally_similar(self, wf1: Dict, wf2: Dict) -> bool:
        """Determine if two workflows are functionally similar"""
        # Compare node types
        types1 = set(wf1.get('node_types', []))
        types2 = set(wf2.get('node_types', []))
        
        if not types1 or not types2:
            return False
            
        # Calculate Jaccard similarity
        intersection = len(types1.intersection(types2))
        union = len(types1.union(types2))
        
        if union == 0:
            return False
            
        similarity = intersection / union
        
        # Also check workflow type
        same_type = wf1.get('workflow_type') == wf2.get('workflow_type')
        
        return similarity > 0.7 and same_type
        
    def _process_duplicate_group(self, workflows: List[Dict], group_type: str) -> Dict[str, Any]:
        """Process a group of duplicate workflows"""
        # Calculate quality scores for each workflow
        scored_workflows = []
        
        for workflow in workflows:
            scores = self._calculate_quality_scores(workflow)
            unique_features = self._identify_unique_features(workflow, workflows)
            
            scored_workflows.append({
                'name': workflow['name'],
                'path': workflow['file_path'],
                'quality_scores': scores,
                'unique_features': unique_features,
                'last_modified': workflow.get('last_modified', 'unknown'),
                'metadata': workflow
            })
            
        # Sort by overall score
        scored_workflows.sort(key=lambda x: x['quality_scores']['overall'], reverse=True)
        
        # Generate recommendation
        recommendation = self._generate_recommendation(scored_workflows, group_type)
        
        return {
            'group_id': hashlib.md5(str(sorted([w['path'] for w in scored_workflows])).encode()).hexdigest()[:8],
            'group_type': group_type,
            'workflows': scored_workflows,
            'recommendation': recommendation
        }
        
    def _calculate_quality_scores(self, workflow: Dict) -> Dict[str, float]:
        """Calculate quality scores for a workflow"""
        scores = {
            'completeness': 0,
            'correctness': 0,
            'documentation': 0,
            'overall': 0
        }
        
        # Correctness (40%)
        if workflow['validation_status'] == 'valid':
            scores['correctness'] = 100
            if not workflow.get('errors'):
                scores['correctness'] = 100
            else:
                scores['correctness'] = max(0, 100 - len(workflow['errors']) * 20)
        
        # Completeness (30%)
        completeness_factors = [
            workflow.get('has_trigger', False) * 20,
            workflow.get('has_error_handling', False) * 30,
            (workflow.get('node_count', 0) > 5) * 20,
            (workflow.get('connections_count', 0) > 3) * 20,
            (len(workflow.get('uses_credentials', [])) > 0) * 10
        ]
        scores['completeness'] = sum(completeness_factors)
        
        # Documentation (20%)
        doc_factors = [
            (workflow.get('description', '') != 'No description found') * 50,
            (workflow.get('name', '') != 'unnamed') * 30,
            (len(workflow.get('name', '')) > 10) * 20
        ]
        scores['documentation'] = sum(doc_factors)
        
        # Overall score with weights
        scores['overall'] = (
            scores['correctness'] * 0.4 +
            scores['completeness'] * 0.3 +
            scores['documentation'] * 0.2 +
            self._calculate_recency_score(workflow) * 0.1
        )
        
        return scores
        
    def _calculate_recency_score(self, workflow: Dict) -> float:
        """Calculate recency score based on last modified date"""
        try:
            last_modified = datetime.fromisoformat(workflow.get('last_modified', '2020-01-01'))
            days_old = (datetime.now() - last_modified).days
            
            if days_old < 30:
                return 100
            elif days_old < 90:
                return 80
            elif days_old < 180:
                return 60
            elif days_old < 365:
                return 40
            else:
                return 20
        except:
            return 0
            
    def _identify_unique_features(self, workflow: Dict, group: List[Dict]) -> List[str]:
        """Identify unique features of a workflow within its group"""
        unique_features = []
        
        # Get this workflow's features
        my_types = set(workflow.get('node_types', []))
        my_creds = set(workflow.get('uses_credentials', []))
        
        # Compare with others in group
        for other in group:
            if other['file_path'] == workflow['file_path']:
                continue
                
            other_types = set(other.get('node_types', []))
            other_creds = set(other.get('uses_credentials', []))
            
            # Find unique node types
            unique_nodes = my_types - other_types
            if unique_nodes:
                unique_features.extend([f"Unique node: {node}" for node in unique_nodes])
                
            # Find unique credentials
            unique_creds = my_creds - other_creds
            if unique_creds:
                unique_features.extend([f"Unique credential: {cred}" for cred in unique_creds])
                
        # Check for special features
        if workflow.get('has_error_handling'):
            unique_features.append("Has error handling")
            
        if workflow.get('node_count', 0) > max(other.get('node_count', 0) for other in group if other['file_path'] != workflow['file_path']):
            unique_features.append("Most comprehensive (highest node count)")
            
        return unique_features[:5]  # Limit to top 5 features
        
    def _generate_recommendation(self, workflows: List[Dict], group_type: str) -> Dict[str, Any]:
        """Generate recommendation for which workflow to keep"""
        # The first workflow has the highest score
        keeper = workflows[0]
        to_remove = [w['name'] for w in workflows[1:]]
        
        # Check if we need to merge features
        merge_features = []
        for workflow in workflows[1:]:
            if workflow['unique_features']:
                merge_features.extend(workflow['unique_features'])
                
        # Generate justification
        justification = self._generate_justification(keeper, workflows, group_type)
        
        return {
            'keep': keeper['name'],
            'remove': to_remove,
            'merge_features': list(set(merge_features))[:5],
            'justification': justification
        }
        
    def _generate_justification(self, keeper: Dict, all_workflows: List[Dict], group_type: str) -> str:
        """Generate detailed justification for the recommendation"""
        reasons = []
        
        scores = keeper['quality_scores']
        
        if scores['correctness'] == 100:
            reasons.append("No validation errors")
        
        if scores['completeness'] > 70:
            reasons.append(f"High completeness score ({scores['completeness']:.0f}%)")
            
        if scores['documentation'] > 50:
            reasons.append("Well documented")
            
        if keeper['unique_features']:
            reasons.append(f"Contains unique features: {', '.join(keeper['unique_features'][:2])}")
            
        # Compare with others
        if len(all_workflows) > 1:
            avg_score = sum(w['quality_scores']['overall'] for w in all_workflows[1:]) / (len(all_workflows) - 1)
            if scores['overall'] > avg_score * 1.2:
                reasons.append(f"Significantly higher quality score ({scores['overall']:.0f} vs avg {avg_score:.0f})")
                
        return f"{group_type.capitalize()} duplicate group. Selected '{keeper['name']}' because: " + "; ".join(reasons)
        
    def _analyze_removal_impact(self, groups: List[Dict]) -> Dict[str, List[str]]:
        """Analyze the impact of removing workflows"""
        safe_to_remove = []
        requires_merge = []
        requires_review = []
        
        for group in groups:
            for workflow in group['workflows'][1:]:  # Skip the keeper
                if not workflow['unique_features']:
                    safe_to_remove.append(workflow['path'])
                elif len(workflow['unique_features']) <= 2:
                    requires_merge.append(workflow['path'])
                else:
                    requires_review.append(workflow['path'])
                    
        return {
            'safe_to_remove': safe_to_remove,
            'requires_feature_merge': requires_merge,
            'requires_further_review': requires_review
        }
        
    def save_analysis(self, analysis: Dict[str, Any], output_file: str):
        """Save analysis to JSON file"""
        with open(output_file, 'w') as f:
            json.dump(analysis, f, indent=2)
            

def main():
    # Load inventory from Task 1
    inventory_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflow_inventory.json'
    
    analyzer = DuplicateAnalyzer(inventory_file)
    analyzer.load_inventory()
    
    # Perform duplicate analysis
    analysis = analyzer.analyze_duplicates()
    
    # Save results
    output_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_duplicate_analysis.json'
    analyzer.save_analysis(analysis, output_file)
    
    # Print summary
    summary = analysis['duplicate_analysis']['summary']
    print(f"Duplicate Analysis Complete:")
    print(f"- Found {summary['duplicate_groups']} duplicate groups")
    print(f"- Recommend removing {summary['workflows_to_remove']} workflows")
    print(f"- {summary['merge_candidates']} groups require feature merging")
    print(f"\nDetailed analysis saved to: {output_file}")
    

if __name__ == "__main__":
    main()