#!/usr/bin/env python3
"""
Analyze and prepare restaurant email CSV for import into VividWalls lead database
"""

import csv
import re
from collections import Counter, defaultdict
import json

def validate_email(email):
    """Validate email format"""
    if not email:
        return False
    
    # Basic email regex
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(pattern, email.lower().strip()):
        return False
    
    # Check for invalid domains
    invalid_domains = [
        'example.com', 'test.com', 'temp.com', 'fake.com',
        'mailinator.com', 'guerrillamail.com'
    ]
    
    domain = email.split('@')[1].lower()
    if domain in invalid_domains:
        return False
    
    # Check for suspicious patterns
    suspicious_patterns = [
        r'^test',
        r'^admin@',
        r'^no-?reply',
        r'^bounce'
    ]
    
    for pattern in suspicious_patterns:
        if re.match(pattern, email.lower()):
            return False
    
    return True

def clean_business_name(name):
    """Clean business name"""
    if not name:
        return ''
    
    # Remove leading dots, spaces, and normalize
    cleaned = re.sub(r'^[.\s]+', '', name)
    cleaned = re.sub(r'\s+', ' ', cleaned)
    cleaned = cleaned.strip().strip(',')
    
    # Skip if too short or just numbers
    if len(cleaned) < 2 or cleaned.isdigit():
        return ''
    
    return cleaned

def analyze_csv(file_path):
    """Analyze CSV file and generate statistics"""
    stats = {
        'total_rows': 0,
        'valid_emails': 0,
        'invalid_emails': 0,
        'missing_emails': 0,
        'duplicates': 0,
        'with_business_name': 0,
        'with_contact_person': 0,
        'domain_distribution': Counter(),
        'invalid_examples': [],
        'data_quality_score': 0
    }
    
    valid_records = []
    seen_emails = set()
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            stats['total_rows'] += 1
            
            # Extract fields
            business_name = clean_business_name(row.get('Business Name', ''))
            contact_person = (row.get('Contact Person', '') or '').strip()
            email = (row.get('Email', '') or '').strip().lower()
            
            # Check email
            if not email:
                stats['missing_emails'] += 1
                continue
            
            if not validate_email(email):
                stats['invalid_emails'] += 1
                if len(stats['invalid_examples']) < 10:
                    stats['invalid_examples'].append({
                        'email': email,
                        'business': business_name,
                        'row': stats['total_rows']
                    })
                continue
            
            # Check for duplicates
            if email in seen_emails:
                stats['duplicates'] += 1
                continue
            
            seen_emails.add(email)
            stats['valid_emails'] += 1
            
            # Extract domain
            domain = email.split('@')[1]
            stats['domain_distribution'][domain] += 1
            
            # Check data completeness
            if business_name:
                stats['with_business_name'] += 1
            if contact_person:
                stats['with_contact_person'] += 1
            
            # Add to valid records
            valid_records.append({
                'email': email,
                'business_name': business_name,
                'contact_person': contact_person,
                'domain': domain
            })
    
    # Calculate data quality score
    if stats['total_rows'] > 0:
        email_quality = stats['valid_emails'] / stats['total_rows']
        completeness = (stats['with_business_name'] + stats['with_contact_person']) / (2 * stats['valid_emails']) if stats['valid_emails'] > 0 else 0
        stats['data_quality_score'] = round((email_quality * 0.6 + completeness * 0.4) * 100, 1)
    
    # Get top domains
    stats['top_domains'] = stats['domain_distribution'].most_common(20)
    
    return stats, valid_records

def generate_report(stats, output_path='email_analysis_report.json'):
    """Generate analysis report"""
    report = {
        'summary': {
            'total_rows': stats['total_rows'],
            'valid_emails': stats['valid_emails'],
            'invalid_emails': stats['invalid_emails'],
            'missing_emails': stats['missing_emails'],
            'duplicates': stats['duplicates'],
            'unique_valid_emails': stats['valid_emails'] - stats['duplicates'],
            'data_quality_score': f"{stats['data_quality_score']}%"
        },
        'completeness': {
            'with_business_name': stats['with_business_name'],
            'with_contact_person': stats['with_contact_person'],
            'business_name_percentage': f"{(stats['with_business_name'] / stats['valid_emails'] * 100):.1f}%" if stats['valid_emails'] > 0 else "0%",
            'contact_person_percentage': f"{(stats['with_contact_person'] / stats['valid_emails'] * 100):.1f}%" if stats['valid_emails'] > 0 else "0%"
        },
        'top_email_domains': stats['top_domains'],
        'invalid_email_examples': stats['invalid_examples'][:10],
        'recommendations': []
    }
    
    # Add recommendations
    if stats['data_quality_score'] < 50:
        report['recommendations'].append("Data quality is low. Consider additional data sources.")
    
    if stats['with_business_name'] < stats['valid_emails'] * 0.5:
        report['recommendations'].append("Many records missing business names. Consider enrichment.")
    
    if stats['duplicates'] > stats['valid_emails'] * 0.1:
        report['recommendations'].append("High duplicate rate. Deduplication recommended.")
    
    # Professional domains check
    professional_domains = sum(1 for d, c in stats['top_domains'] if d not in ['gmail.com', 'yahoo.com', 'hotmail.com', 'aol.com'])
    if professional_domains < len(stats['top_domains']) * 0.3:
        report['recommendations'].append("Low percentage of professional email domains.")
    
    with open(output_path, 'w') as f:
        json.dump(report, f, indent=2)
    
    return report

def export_clean_csv(valid_records, output_path='cleaned_restaurant_emails.csv'):
    """Export cleaned records to CSV"""
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        fieldnames = ['email', 'business_name', 'contact_person', 'domain', 'segment']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        
        writer.writeheader()
        for record in valid_records:
            record['segment'] = 'commercial_buyers'  # Restaurant segment
            writer.writerow(record)
    
    print(f"Exported {len(valid_records)} cleaned records to {output_path}")

if __name__ == "__main__":
    # Analyze the CSV file
    csv_path = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/email_list_restaurants.csv"
    
    print("Analyzing restaurant email CSV...")
    stats, valid_records = analyze_csv(csv_path)
    
    # Generate report
    report = generate_report(stats, "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/email_analysis_report.json")
    
    # Print summary
    print("\n=== Email CSV Analysis Summary ===")
    print(f"Total rows: {stats['total_rows']:,}")
    print(f"Valid emails: {stats['valid_emails']:,}")
    print(f"Invalid emails: {stats['invalid_emails']:,}")
    print(f"Missing emails: {stats['missing_emails']:,}")
    print(f"Duplicates: {stats['duplicates']:,}")
    print(f"Data quality score: {stats['data_quality_score']}%")
    
    print("\n=== Top Email Domains ===")
    for domain, count in stats['top_domains'][:10]:
        print(f"{domain}: {count}")
    
    print("\n=== Recommendations ===")
    for rec in report['recommendations']:
        print(f"- {rec}")
    
    # Export cleaned data
    if valid_records:
        export_clean_csv(valid_records, "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/cleaned_restaurant_emails.csv")
    
    print(f"\nAnalysis report saved to: email_analysis_report.json")