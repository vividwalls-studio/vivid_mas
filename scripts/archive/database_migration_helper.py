#!/usr/bin/env python3
"""
Database Migration Helper for VividWalls MAS
Assists with migrating from complex 68-table schema to simplified 30-table schema
"""

import os
import json
import asyncio
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import asyncpg
from dotenv import load_dotenv

load_dotenv()

class DatabaseMigrationHelper:
    def __init__(self):
        self.db_url = os.getenv('SUPABASE_DB_URL')
        self.conn = None
        self.migration_stats = {
            'tables_processed': 0,
            'records_migrated': 0,
            'errors': [],
            'warnings': []
        }
    
    async def connect(self):
        """Establish database connection"""
        self.conn = await asyncpg.connect(self.db_url)
        print("✅ Connected to database")
    
    async def disconnect(self):
        """Close database connection"""
        if self.conn:
            await self.conn.close()
            print("✅ Disconnected from database")
    
    async def analyze_current_schema(self) -> Dict:
        """Analyze current database schema"""
        print("\n📊 Analyzing current schema...")
        
        # Get all tables
        tables = await self.conn.fetch("""
            SELECT table_name, 
                   (SELECT COUNT(*) FROM information_schema.columns 
                    WHERE table_schema = 'public' AND table_name = t.table_name) as column_count
            FROM information_schema.tables t
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        """)
        
        # Get row counts for each table
        table_stats = {}
        for table in tables:
            count = await self.conn.fetchval(f"SELECT COUNT(*) FROM {table['table_name']}")
            table_stats[table['table_name']] = {
                'columns': table['column_count'],
                'rows': count
            }
        
        # Identify duplicate/similar tables
        duplicates = self._find_duplicate_tables(table_stats)
        
        return {
            'total_tables': len(tables),
            'table_stats': table_stats,
            'duplicates': duplicates,
            'total_rows': sum(t['rows'] for t in table_stats.values())
        }
    
    def _find_duplicate_tables(self, table_stats: Dict) -> List[Tuple[str, str]]:
        """Find potentially duplicate tables"""
        duplicates = []
        table_names = list(table_stats.keys())
        
        duplicate_patterns = [
            ('agents', 'agent_personas'),
            ('products', 'vividwalls_products'),
            ('customer_segments', 'customer_personas'),
            ('agent_tasks', 'tasks'),
            ('agent_workflows', 'workflows')
        ]
        
        for pattern in duplicate_patterns:
            if pattern[0] in table_names and pattern[1] in table_names:
                duplicates.append(pattern)
        
        return duplicates
    
    async def consolidate_agents(self):
        """Consolidate 48+ agents into 11 simplified agents"""
        print("\n🤖 Consolidating agents...")
        
        # Map old agents to new structure
        agent_mapping = {
            # Directors consolidation
            'marketing_director': 'Revenue Director',
            'sales_director': 'Revenue Director',
            'social_media_director': 'Revenue Director',
            
            # Specialist consolidation
            'email_marketing_agent': 'Marketing Specialist',
            'content_strategy_agent': 'Marketing Specialist',
            'seo_agent': 'Marketing Specialist',
            'campaign_management_agent': 'Marketing Specialist',
            
            # Sales agents to Sales Specialist
            'hospitality_sales_agent': 'Sales Specialist',
            'corporate_sales_agent': 'Sales Specialist',
            'healthcare_sales_agent': 'Sales Specialist',
            'retail_sales_agent': 'Sales Specialist',
            'real_estate_sales_agent': 'Sales Specialist',
            'homeowner_sales_agent': 'Sales Specialist',
            'renter_sales_agent': 'Sales Specialist',
            'interior_designer_sales_agent': 'Sales Specialist',
            'art_collector_sales_agent': 'Sales Specialist',
            'gift_buyer_sales_agent': 'Sales Specialist',
            'millennial_gen_z_sales_agent': 'Sales Specialist',
            'global_customer_sales_agent': 'Sales Specialist',
        }
        
        # Count agents before consolidation
        old_count = await self.conn.fetchval("SELECT COUNT(*) FROM agents")
        print(f"  Current agents: {old_count}")
        
        # Get all existing agents
        existing_agents = await self.conn.fetch("SELECT * FROM agents")
        
        # Prepare consolidated agent data
        consolidated_agents = {}
        for agent in existing_agents:
            new_name = agent_mapping.get(agent['name'], agent['name'])
            
            if new_name not in consolidated_agents:
                consolidated_agents[new_name] = {
                    'capabilities': [],
                    'knowledge_bases': [],
                    'mcp_tools': set()
                }
            
            # Aggregate capabilities
            if agent.get('capabilities'):
                consolidated_agents[new_name]['capabilities'].extend(agent['capabilities'])
            
            # Aggregate MCP tools
            if agent.get('mcp_tools'):
                consolidated_agents[new_name]['mcp_tools'].update(agent['mcp_tools'])
        
        print(f"  Consolidated to: {len(consolidated_agents)} agents")
        return consolidated_agents
    
    async def migrate_customers(self):
        """Migrate and clean up customer data"""
        print("\n👥 Migrating customers...")
        
        # Check for duplicate customers
        duplicates = await self.conn.fetch("""
            SELECT email, COUNT(*) as count
            FROM customers
            GROUP BY email
            HAVING COUNT(*) > 1
        """)
        
        if duplicates:
            print(f"  ⚠️  Found {len(duplicates)} duplicate customer emails")
            for dup in duplicates:
                # Keep the customer with most recent order
                await self.conn.execute("""
                    DELETE FROM customers
                    WHERE email = $1
                    AND id NOT IN (
                        SELECT id FROM customers
                        WHERE email = $1
                        ORDER BY last_order_date DESC NULLS LAST
                        LIMIT 1
                    )
                """, dup['email'])
        
        # Calculate customer metrics
        await self.conn.execute("""
            UPDATE customers c
            SET 
                average_order_value = COALESCE(
                    (SELECT AVG(total_amount) 
                     FROM orders 
                     WHERE customer_id = c.id), 0),
                vip_status = CASE 
                    WHEN total_spent > 10000 THEN true
                    ELSE false
                END
        """)
        
        count = await self.conn.fetchval("SELECT COUNT(*) FROM customers")
        print(f"  ✅ Migrated {count} customers")
    
    async def create_customer_segments(self):
        """Automatically assign customers to segments"""
        print("\n🎯 Creating customer segments...")
        
        # Define segment rules
        segment_rules = [
            {
                'name': 'Interior Designers',
                'sql': """
                    SELECT DISTINCT customer_id FROM customers
                    WHERE company ILIKE '%design%'
                    OR company ILIKE '%interior%'
                    OR tags && ARRAY['interior_designer', 'designer', 'trade']
                """
            },
            {
                'name': 'Corporate Buyers',
                'sql': """
                    SELECT DISTINCT customer_id FROM customers
                    WHERE company IS NOT NULL
                    AND (company ILIKE '%corp%' 
                         OR company ILIKE '%llc%'
                         OR company ILIKE '%inc%'
                         OR company ILIKE '%company%')
                """
            },
            {
                'name': 'High Value Customers',
                'sql': """
                    SELECT DISTINCT id as customer_id FROM customers
                    WHERE total_spent > 5000
                    OR orders_count > 10
                """
            }
        ]
        
        for rule in segment_rules:
            # Get segment ID
            segment_id = await self.conn.fetchval(
                "SELECT id FROM customer_segments WHERE name = $1",
                rule['name']
            )
            
            if segment_id:
                # Get customers matching rule
                customers = await self.conn.fetch(rule['sql'])
                
                # Assign to segment
                for customer in customers:
                    await self.conn.execute("""
                        INSERT INTO customer_segment_members 
                        (customer_id, segment_id, score)
                        VALUES ($1, $2, $3)
                        ON CONFLICT (customer_id, segment_id) 
                        DO UPDATE SET score = EXCLUDED.score
                    """, customer['customer_id'], segment_id, 85.0)
                
                print(f"  ✅ Assigned {len(customers)} customers to {rule['name']}")
    
    async def setup_initial_goals(self):
        """Create initial business goals"""
        print("\n🎯 Setting up initial goals...")
        
        # Get agent IDs
        agents = await self.conn.fetch("""
            SELECT id, name FROM agents_new 
            WHERE type = 'director'
        """)
        
        agent_map = {a['name']: a['id'] for a in agents}
        
        # Define initial goals
        goals = [
            {
                'name': 'Q1 2025 Revenue Target',
                'type': 'revenue',
                'target_value': 500000,
                'owner': 'Revenue Director',
                'subgoals': [
                    ('January Revenue', 150000),
                    ('February Revenue', 160000),
                    ('March Revenue', 190000)
                ]
            },
            {
                'name': 'Customer Satisfaction Excellence',
                'type': 'customer_satisfaction',
                'target_value': 95,
                'owner': 'Customer Director',
                'subgoals': [
                    ('Response Time < 24h', 100),
                    ('Resolution Rate', 90),
                    ('NPS Score', 70)
                ]
            },
            {
                'name': 'Operational Efficiency',
                'type': 'efficiency',
                'target_value': 5,
                'owner': 'Operations Director',
                'subgoals': [
                    ('Order Processing Time', 2),
                    ('Shipping Time', 3),
                    ('Inventory Accuracy', 98)
                ]
            }
        ]
        
        for goal in goals:
            # Create parent goal
            parent_id = await self.conn.fetchval("""
                INSERT INTO goals (name, type, target_value, owner_agent_id, target_date)
                VALUES ($1, $2, $3, $4, CURRENT_DATE + INTERVAL '3 months')
                RETURNING id
            """, goal['name'], goal['type'], goal['target_value'], agent_map.get(goal['owner']))
            
            # Create subgoals
            for subgoal_name, target in goal['subgoals']:
                await self.conn.execute("""
                    INSERT INTO goals (name, type, target_value, parent_goal_id, owner_agent_id)
                    VALUES ($1, $2, $3, $4, $5)
                """, subgoal_name, goal['type'], target, parent_id, agent_map.get(goal['owner']))
        
        print("  ✅ Created initial goal hierarchy")
    
    async def validate_migration(self) -> Dict:
        """Validate the migration results"""
        print("\n✅ Validating migration...")
        
        validation_results = {
            'agents': {},
            'customers': {},
            'relationships': {},
            'data_integrity': {}
        }
        
        # Validate agents
        old_agents = await self.conn.fetchval("SELECT COUNT(*) FROM agents")
        new_agents = await self.conn.fetchval("SELECT COUNT(*) FROM agents_new")
        validation_results['agents'] = {
            'old_count': old_agents,
            'new_count': new_agents,
            'reduction': f"{((old_agents - new_agents) / old_agents * 100):.1f}%"
        }
        
        # Validate relationships
        orphaned_tasks = await self.conn.fetchval("""
            SELECT COUNT(*) FROM tasks t
            WHERE NOT EXISTS (
                SELECT 1 FROM agents_new a 
                WHERE a.id = t.assigned_agent_id
            )
        """)
        
        validation_results['relationships']['orphaned_tasks'] = orphaned_tasks
        
        # Check for null foreign keys
        null_checks = [
            ('workflows without owner', 'workflows', 'owner_agent_id'),
            ('tasks without agent', 'tasks', 'assigned_agent_id'),
            ('orders without customer', 'orders', 'customer_id')
        ]
        
        for check_name, table, column in null_checks:
            count = await self.conn.fetchval(
                f"SELECT COUNT(*) FROM {table} WHERE {column} IS NULL"
            )
            validation_results['data_integrity'][check_name] = count
        
        return validation_results
    
    async def generate_migration_report(self):
        """Generate comprehensive migration report"""
        print("\n📄 Generating migration report...")
        
        report = {
            'timestamp': datetime.now().isoformat(),
            'schema_analysis': await self.analyze_current_schema(),
            'validation': await self.validate_migration(),
            'statistics': self.migration_stats
        }
        
        # Save report
        with open('migration_report.json', 'w') as f:
            json.dump(report, f, indent=2)
        
        print("\n" + "="*50)
        print("MIGRATION SUMMARY")
        print("="*50)
        print(f"Tables: {report['schema_analysis']['total_tables']} → 30")
        print(f"Total Records: {report['schema_analysis']['total_rows']:,}")
        print(f"Agents: {report['validation']['agents']['old_count']} → {report['validation']['agents']['new_count']}")
        print(f"Reduction: {report['validation']['agents']['reduction']}")
        
        if report['statistics']['errors']:
            print(f"\n⚠️  Errors: {len(report['statistics']['errors'])}")
            for error in report['statistics']['errors'][:5]:
                print(f"  - {error}")
        
        print("\n✅ Report saved to migration_report.json")

async def main():
    """Run the migration helper"""
    helper = DatabaseMigrationHelper()
    
    try:
        await helper.connect()
        
        # Analyze current state
        schema_info = await helper.analyze_current_schema()
        print(f"\nCurrent schema: {schema_info['total_tables']} tables, {schema_info['total_rows']:,} total rows")
        
        if schema_info['duplicates']:
            print(f"\n⚠️  Found {len(schema_info['duplicates'])} duplicate table patterns:")
            for dup in schema_info['duplicates']:
                print(f"  - {dup[0]} ↔ {dup[1]}")
        
        # Run migration tasks
        print("\n🚀 Starting migration tasks...")
        
        # 1. Consolidate agents
        await helper.consolidate_agents()
        
        # 2. Migrate customers
        await helper.migrate_customers()
        
        # 3. Create segments
        await helper.create_customer_segments()
        
        # 4. Setup goals
        await helper.setup_initial_goals()
        
        # 5. Validate
        validation = await helper.validate_migration()
        
        # 6. Generate report
        await helper.generate_migration_report()
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        helper.migration_stats['errors'].append(str(e))
    finally:
        await helper.disconnect()

if __name__ == "__main__":
    asyncio.run(main())