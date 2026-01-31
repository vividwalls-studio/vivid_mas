#!/usr/bin/env python3
"""
N8N Workflow Migration Script
Safely migrates n8n workflows and credentials from backup to new system
"""

import json
import os
import sys
import psycopg2
from datetime import datetime
import subprocess
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('n8n_migration.log'),
        logging.StreamHandler(sys.stdout)
    ]
)

class N8NMigrator:
    def __init__(self, backup_path, target_host='localhost'):
        self.backup_path = backup_path
        self.target_host = target_host
        self.encryption_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4ZjE3Nzk5ZS1mYzIzLTQ5OGItOTUxZS05N2Y4MzUzNGRhNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwMDk5NTI0fQ.FkHcnlHhtFw1EtgPZ8tiefY4Q-O3CEhq8VddvwllAWU"
        
    def verify_encryption_key(self):
        """Verify the encryption key matches the backup"""
        logging.info("Verifying encryption key...")
        
        # Check if n8n container has correct key
        result = subprocess.run(
            ['docker', 'exec', 'n8n', 'printenv', 'N8N_ENCRYPTION_KEY'],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            logging.error("Failed to check n8n encryption key")
            return False
            
        current_key = result.stdout.strip()
        if current_key != self.encryption_key:
            logging.error(f"Encryption key mismatch!")
            logging.error(f"Expected: {self.encryption_key}")
            logging.error(f"Current: {current_key}")
            return False
            
        logging.info("Encryption key verified successfully")
        return True
        
    def backup_current_state(self):
        """Create backup of current n8n state"""
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_dir = f"n8n_backup_{timestamp}"
        
        logging.info(f"Creating backup of current state in {backup_dir}")
        os.makedirs(backup_dir, exist_ok=True)
        
        # Export current workflows
        subprocess.run([
            'docker', 'exec', 'postgres',
            'pg_dump', '-U', 'postgres', '-d', 'postgres',
            '-t', 'workflow_entity',
            '-t', 'credentials_entity',
            '-f', f'/tmp/n8n_backup_{timestamp}.sql'
        ])
        
        # Copy backup locally
        subprocess.run([
            'docker', 'cp',
            f'postgres:/tmp/n8n_backup_{timestamp}.sql',
            f'{backup_dir}/database_backup.sql'
        ])
        
        logging.info(f"Backup created in {backup_dir}")
        return backup_dir
        
    def load_workflows_from_json(self):
        """Load workflows from JSON backup files"""
        workflow_files = [
            f"{self.backup_path}/20250626_180723/codebase/backups/n8n/workflows/latest.json",
            f"{self.backup_path}/20250626_180723/codebase/n8n-workflows-backup.json"
        ]
        
        workflows = []
        for file_path in workflow_files:
            if os.path.exists(file_path):
                logging.info(f"Loading workflows from {file_path}")
                with open(file_path, 'r') as f:
                    data = json.load(f)
                    if isinstance(data, list):
                        workflows.extend(data)
                    elif isinstance(data, dict) and 'workflows' in data:
                        workflows.extend(data['workflows'])
                        
        logging.info(f"Loaded {len(workflows)} workflows from backup")
        return workflows
        
    def load_credentials_from_json(self):
        """Load credentials from JSON backup files"""
        cred_file = f"{self.backup_path}/20250626_180723/codebase/backups/n8n/credentials/latest.json"
        
        if os.path.exists(cred_file):
            logging.info(f"Loading credentials from {cred_file}")
            with open(cred_file, 'r') as f:
                return json.load(f)
        
        logging.warning("No credentials backup found")
        return []
        
    def import_to_database(self, workflows, credentials):
        """Import workflows and credentials to PostgreSQL"""
        logging.info("Connecting to PostgreSQL...")
        
        conn = psycopg2.connect(
            host=self.target_host,
            port=5433,  # postgres container port
            database='postgres',
            user='postgres',
            password='myqP9lSMLobnuIfkUpXQzZg07'
        )
        
        cur = conn.cursor()
        
        # Import workflows
        logging.info("Importing workflows...")
        for workflow in workflows:
            try:
                # Check if workflow already exists
                cur.execute(
                    "SELECT id FROM workflow_entity WHERE id = %s",
                    (workflow.get('id'),)
                )
                
                if cur.fetchone():
                    logging.info(f"Workflow {workflow.get('name')} already exists, skipping")
                    continue
                    
                # Insert workflow
                cur.execute("""
                    INSERT INTO workflow_entity (id, name, active, nodes, connections, settings, staticData, createdAt, updatedAt)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    workflow.get('id'),
                    workflow.get('name'),
                    workflow.get('active', False),
                    json.dumps(workflow.get('nodes', [])),
                    json.dumps(workflow.get('connections', {})),
                    json.dumps(workflow.get('settings', {})),
                    json.dumps(workflow.get('staticData', {})),
                    workflow.get('createdAt', datetime.now().isoformat()),
                    workflow.get('updatedAt', datetime.now().isoformat())
                ))
                
                logging.info(f"Imported workflow: {workflow.get('name')}")
                
            except Exception as e:
                logging.error(f"Failed to import workflow {workflow.get('name')}: {e}")
                conn.rollback()
                continue
                
        # Import credentials
        logging.info("Importing credentials...")
        for credential in credentials:
            try:
                # Check if credential already exists
                cur.execute(
                    "SELECT id FROM credentials_entity WHERE id = %s",
                    (credential.get('id'),)
                )
                
                if cur.fetchone():
                    logging.info(f"Credential {credential.get('name')} already exists, skipping")
                    continue
                    
                # Insert credential
                cur.execute("""
                    INSERT INTO credentials_entity (id, name, data, type, nodesAccess, createdAt, updatedAt)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (
                    credential.get('id'),
                    credential.get('name'),
                    credential.get('data'),  # This should be encrypted
                    credential.get('type'),
                    json.dumps(credential.get('nodesAccess', [])),
                    credential.get('createdAt', datetime.now().isoformat()),
                    credential.get('updatedAt', datetime.now().isoformat())
                ))
                
                logging.info(f"Imported credential: {credential.get('name')}")
                
            except Exception as e:
                logging.error(f"Failed to import credential {credential.get('name')}: {e}")
                conn.rollback()
                continue
                
        conn.commit()
        cur.close()
        conn.close()
        
        logging.info("Database import completed")
        
    def verify_migration(self):
        """Verify the migration was successful"""
        logging.info("Verifying migration...")
        
        # Check workflow count
        result = subprocess.run([
            'docker', 'exec', 'postgres',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-t', '-c', 'SELECT COUNT(*) FROM workflow_entity;'
        ], capture_output=True, text=True)
        
        workflow_count = int(result.stdout.strip())
        logging.info(f"Total workflows in database: {workflow_count}")
        
        # Check credential count
        result = subprocess.run([
            'docker', 'exec', 'postgres',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-t', '-c', 'SELECT COUNT(*) FROM credentials_entity;'
        ], capture_output=True, text=True)
        
        credential_count = int(result.stdout.strip())
        logging.info(f"Total credentials in database: {credential_count}")
        
        return workflow_count >= 97  # Expected minimum workflows
        
    def migrate(self):
        """Execute the full migration process"""
        logging.info("Starting n8n migration process...")
        
        # Step 1: Verify encryption key
        if not self.verify_encryption_key():
            logging.error("Encryption key verification failed. Please fix the key first.")
            return False
            
        # Step 2: Backup current state
        backup_dir = self.backup_current_state()
        
        # Step 3: Load data from backup
        workflows = self.load_workflows_from_json()
        credentials = self.load_credentials_from_json()
        
        if not workflows:
            logging.error("No workflows found in backup")
            return False
            
        # Step 4: Import to database
        try:
            self.import_to_database(workflows, credentials)
        except Exception as e:
            logging.error(f"Import failed: {e}")
            return False
            
        # Step 5: Verify migration
        if self.verify_migration():
            logging.info("Migration completed successfully!")
            return True
        else:
            logging.error("Migration verification failed")
            return False


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python migrate_n8n_workflows.py <backup_path>")
        sys.exit(1)
        
    backup_path = sys.argv[1]
    migrator = N8NMigrator(backup_path)
    
    if migrator.migrate():
        print("Migration successful!")
    else:
        print("Migration failed. Check logs for details.")
        sys.exit(1)