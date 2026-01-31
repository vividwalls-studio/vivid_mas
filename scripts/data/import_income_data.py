#!/usr/bin/env python3
"""
Import US County Income Data into VividWalls MAS
This script imports household income ranking data from CSV into Supabase
for use by marketing agents in geographic targeting.
"""

import os
import sys
import csv
import re
from typing import Dict, List, Optional
from datetime import datetime
import asyncio
import logging
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))

try:
    from supabase import create_client, Client
    from dotenv import load_dotenv
except ImportError:
    print("Installing required packages...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "supabase", "python-dotenv"])
    from supabase import create_client, Client
    from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class IncomeDataImporter:
    """Handles importing income data from CSV to Supabase"""
    
    def __init__(self):
        """Initialize Supabase client"""
        supabase_url = os.getenv('SUPABASE_URL')
        supabase_key = os.getenv('SUPABASE_ANON_KEY')
        
        if not supabase_url or not supabase_key:
            raise ValueError("Missing SUPABASE_URL or SUPABASE_ANON_KEY in environment variables")
        
        self.supabase: Client = create_client(supabase_url, supabase_key)
        self.csv_path = project_root / "Income_Ranking_By_State - household_income_ranking_by_state.csv"
        
    def parse_income_value(self, income_str: str) -> int:
        """Parse income string to integer value"""
        # Remove $ and commas, handle the format from CSV
        clean_str = income_str.strip().replace('$', '').replace(',', '')
        
        # Handle cases where value might be truncated (e.g., "$147" meaning $147,000)
        if clean_str.isdigit() and int(clean_str) < 1000:
            return int(clean_str) * 1000
        else:
            return int(clean_str)
    
    def calculate_percentile_rank(self, rank: int, total_counties: int) -> float:
        """Calculate percentile rank based on position"""
        return round(((total_counties - rank + 1) / total_counties) * 100, 2)
    
    def read_csv_data(self) -> List[Dict]:
        """Read and parse CSV data"""
        logger.info(f"Reading CSV from: {self.csv_path}")
        
        data = []
        total_rows = 0
        
        try:
            with open(self.csv_path, 'r', encoding='utf-8') as file:
                # Count total rows first
                total_rows = sum(1 for line in file) - 1  # Subtract header
                file.seek(0)
                
                reader = csv.DictReader(file)
                
                for row in reader:
                    try:
                        # Parse the data
                        income_value = self.parse_income_value(row['Median Household Income'])
                        rank = int(row['Household Rank'])
                        
                        parsed_row = {
                            'household_rank': rank,
                            'county_name': row['County or Equivalent'].strip(),
                            'state_name': row['State'].strip(),
                            'median_household_income': income_value,
                            'percentile_rank': self.calculate_percentile_rank(rank, total_rows)
                        }
                        
                        data.append(parsed_row)
                        
                    except Exception as e:
                        logger.warning(f"Error parsing row {row}: {e}")
                        continue
        
        except FileNotFoundError:
            logger.error(f"CSV file not found at {self.csv_path}")
            raise
        
        logger.info(f"Successfully parsed {len(data)} rows from CSV")
        return data
    
    def enrich_data(self, data: List[Dict]) -> List[Dict]:
        """Add calculated fields to the data"""
        logger.info("Enriching data with calculated fields...")
        
        for row in data:
            income = row['median_household_income']
            rank = row['household_rank']
            
            # Calculate income bracket
            if income < 50000:
                row['income_bracket'] = 'under_50k'
            elif income < 75000:
                row['income_bracket'] = '50k_75k'
            elif income < 100000:
                row['income_bracket'] = '75k_100k'
            elif income < 150000:
                row['income_bracket'] = '100k_150k'
            else:
                row['income_bracket'] = '150k_plus'
            
            # Calculate market tier
            if income >= 100000 or rank <= 200:
                row['market_tier'] = 'premium'
            elif income >= 70000 or rank <= 500:
                row['market_tier'] = 'mid'
            else:
                row['market_tier'] = 'value'
            
            # Calculate art affinity score (simplified version)
            income_score = min(5, income / 30000)
            education_score = 2.5  # Default, would be enriched with real data
            row['art_affinity_score'] = round(min(10, income_score + education_score), 2)
            
            # Calculate market potential score
            if row['market_tier'] == 'premium':
                base_score = 8
            elif row['market_tier'] == 'mid':
                base_score = 6
            else:
                base_score = 4
            
            # Adjust based on income
            income_adjustment = min(2, (income - 50000) / 50000)
            row['market_potential_score'] = round(min(10, base_score + income_adjustment), 2)
            
            # Recommended price tier
            if income >= 120000:
                row['recommended_price_tier'] = 'luxury'
            elif income >= 85000:
                row['recommended_price_tier'] = 'premium'
            elif income >= 60000:
                row['recommended_price_tier'] = 'standard'
            else:
                row['recommended_price_tier'] = 'value'
        
        return data
    
    def get_state_id(self, state_name: str) -> Optional[str]:
        """Get state ID from the us_states table"""
        try:
            result = self.supabase.table('us_states').select('id').eq('state_name', state_name).execute()
            if result.data and len(result.data) > 0:
                return result.data[0]['id']
            else:
                logger.warning(f"State not found: {state_name}")
                return None
        except Exception as e:
            logger.error(f"Error getting state ID for {state_name}: {e}")
            return None
    
    def import_to_supabase(self, data: List[Dict]):
        """Import data to Supabase in batches"""
        logger.info(f"Starting import of {len(data)} records to Supabase...")
        
        # First, get all state IDs
        state_ids = {}
        for row in data:
            state_name = row['state_name']
            if state_name not in state_ids:
                state_id = self.get_state_id(state_name)
                if state_id:
                    state_ids[state_name] = state_id
        
        # Add state IDs to data
        for row in data:
            row['state_id'] = state_ids.get(row['state_name'])
        
        # Import in batches
        batch_size = 100
        success_count = 0
        error_count = 0
        
        for i in range(0, len(data), batch_size):
            batch = data[i:i + batch_size]
            
            try:
                result = self.supabase.table('geographic_income_data').insert(batch).execute()
                success_count += len(batch)
                logger.info(f"Imported batch {i//batch_size + 1}: {len(batch)} records")
                
            except Exception as e:
                error_count += len(batch)
                logger.error(f"Error importing batch {i//batch_size + 1}: {e}")
                
                # Try individual inserts for failed batch
                for row in batch:
                    try:
                        self.supabase.table('geographic_income_data').insert(row).execute()
                        success_count += 1
                        error_count -= 1
                    except Exception as row_error:
                        logger.error(f"Failed to import {row['county_name']}, {row['state_name']}: {row_error}")
        
        logger.info(f"Import complete! Success: {success_count}, Errors: {error_count}")
        
        # Refresh materialized view
        try:
            self.supabase.rpc('refresh_materialized_view', {'view_name': 'regional_market_analysis'}).execute()
            logger.info("Refreshed regional market analysis view")
        except Exception as e:
            logger.warning(f"Could not refresh materialized view: {e}")
    
    def generate_import_summary(self):
        """Generate a summary of the imported data"""
        logger.info("Generating import summary...")
        
        try:
            # Get summary statistics
            summary = self.supabase.rpc('get_regional_market_summary').execute()
            
            print("\n" + "="*60)
            print("IMPORT SUMMARY")
            print("="*60)
            
            if summary.data:
                print("\nRegional Market Summary:")
                print(f"{'Region':<20} {'Counties':<10} {'Avg Income':<15} {'Premium Markets':<15}")
                print("-" * 60)
                
                for region in summary.data:
                    print(f"{region['region']:<20} {region['total_counties']:<10} "
                          f"${region['avg_income']:,:<14} {region['premium_markets']:<15}")
            
            # Get top markets
            top_markets = self.supabase.table('geographic_income_data')\
                .select('county_name, state_name, median_household_income, market_tier')\
                .order('median_household_income', desc=True)\
                .limit(10)\
                .execute()
            
            if top_markets.data:
                print("\nTop 10 Markets by Income:")
                print(f"{'County':<30} {'State':<15} {'Median Income':<15} {'Tier':<10}")
                print("-" * 70)
                
                for market in top_markets.data:
                    print(f"{market['county_name']:<30} {market['state_name']:<15} "
                          f"${market['median_household_income']:,:<14} {market['market_tier']:<10}")
            
            print("\n" + "="*60)
            
        except Exception as e:
            logger.error(f"Error generating summary: {e}")
    
    def run(self):
        """Execute the full import process"""
        try:
            # Read CSV data
            data = self.read_csv_data()
            
            # Enrich with calculated fields
            enriched_data = self.enrich_data(data)
            
            # Import to Supabase
            self.import_to_supabase(enriched_data)
            
            # Generate summary
            self.generate_import_summary()
            
            logger.info("Import process completed successfully!")
            
        except Exception as e:
            logger.error(f"Import process failed: {e}")
            raise


def main():
    """Main entry point"""
    print("\nVividWalls Income Data Importer")
    print("=" * 40)
    
    try:
        importer = IncomeDataImporter()
        importer.run()
        
        print("\n✅ Data import completed successfully!")
        print("\nMarketing agents can now access this data through:")
        print("- get_market_intelligence() function")
        print("- get_regional_market_summary() function")
        print("- top_art_markets view")
        print("- geographic_targeting_rules table")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()