#!/usr/bin/env python3
"""
Migration Validation Script
Validates all aspects of the VividWalls MAS migration
"""

import subprocess
import json
import sys
import psycopg2
from datetime import datetime
from typing import Dict, List, Tuple

class MigrationValidator:
    def __init__(self):
        self.results = {
            'timestamp': datetime.now().isoformat(),
            'checks': {},
            'errors': [],
            'warnings': []
        }
        
    def run_command(self, command: List[str]) -> Tuple[bool, str, str]:
        """Run a command and return success, stdout, stderr"""
        try:
            result = subprocess.run(command, capture_output=True, text=True)
            return result.returncode == 0, result.stdout, result.stderr
        except Exception as e:
            return False, "", str(e)
            
    def check_encryption_key(self):
        """Validate n8n encryption key consistency"""
        print("Checking n8n encryption key...")
        
        # Expected key from backup
        expected_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4ZjE3Nzk5ZS1mYzIzLTQ5OGItOTUxZS05N2Y4MzUzNGRhNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwMDk5NTI0fQ.FkHcnlHhtFw1EtgPZ8tiefY4Q-O3CEhq8VddvwllAWU"
        
        # Check .env file
        success, stdout, _ = self.run_command(['grep', '^N8N_ENCRYPTION_KEY=', '/root/vivid_mas/.env'])
        if success:
            env_key = stdout.strip().split('=')[1]
            if env_key == expected_key:
                self.results['checks']['env_encryption_key'] = 'PASS'
            else:
                self.results['checks']['env_encryption_key'] = 'FAIL'
                self.results['errors'].append("Encryption key in .env doesn't match expected")
        else:
            self.results['checks']['env_encryption_key'] = 'FAIL'
            self.results['errors'].append("Encryption key not found in .env")
            
        # Check container
        success, stdout, _ = self.run_command(['docker', 'exec', 'n8n', 'printenv', 'N8N_ENCRYPTION_KEY'])
        if success:
            container_key = stdout.strip()
            if container_key == expected_key:
                self.results['checks']['container_encryption_key'] = 'PASS'
            else:
                self.results['checks']['container_encryption_key'] = 'FAIL'
                self.results['errors'].append("Container encryption key doesn't match expected")
        else:
            self.results['checks']['container_encryption_key'] = 'FAIL'
            self.results['errors'].append("Failed to check container encryption key")
            
    def check_network_configuration(self):
        """Validate Docker network configuration"""
        print("Checking Docker network configuration...")
        
        # Get all containers and their networks
        success, stdout, _ = self.run_command(['docker', 'ps', '-a', '--format', 'json'])
        if not success:
            self.results['checks']['network_configuration'] = 'FAIL'
            self.results['errors'].append("Failed to list containers")
            return
            
        containers_on_wrong_network = []
        for line in stdout.strip().split('\n'):
            if line:
                container = json.loads(line)
                networks = container.get('Networks', '').split(',')
                if 'vivid_mas' not in networks:
                    containers_on_wrong_network.append(container['Names'])
                    
        if containers_on_wrong_network:
            self.results['checks']['network_configuration'] = 'FAIL'
            self.results['errors'].append(f"Containers on wrong network: {containers_on_wrong_network}")
        else:
            self.results['checks']['network_configuration'] = 'PASS'
            
    def check_database_connections(self):
        """Validate database connections and data"""
        print("Checking database connections...")
        
        # Check n8n PostgreSQL
        try:
            conn = psycopg2.connect(
                host='localhost',
                port=5433,
                database='postgres',
                user='postgres',
                password='myqP9lSMLobnuIfkUpXQzZg07'
            )
            cur = conn.cursor()
            
            # Check workflow count
            cur.execute("SELECT COUNT(*) FROM workflow_entity")
            workflow_count = cur.fetchone()[0]
            
            if workflow_count >= 97:
                self.results['checks']['n8n_workflows'] = f'PASS ({workflow_count} workflows)'
            else:
                self.results['checks']['n8n_workflows'] = f'WARN ({workflow_count} workflows, expected 97+)'
                self.results['warnings'].append(f"Only {workflow_count} workflows found")
                
            # Check credentials
            cur.execute("SELECT COUNT(*) FROM credentials_entity")
            cred_count = cur.fetchone()[0]
            self.results['checks']['n8n_credentials'] = f'PASS ({cred_count} credentials)'
            
            cur.close()
            conn.close()
        except Exception as e:
            self.results['checks']['n8n_database'] = 'FAIL'
            self.results['errors'].append(f"Failed to connect to n8n database: {e}")
            
    def check_mcp_servers(self):
        """Validate MCP server setup"""
        print("Checking MCP servers...")
        
        # Check if n8n can access MCP servers
        success, stdout, _ = self.run_command(['docker', 'exec', 'n8n', 'ls', '/opt/mcp-servers'])
        if success:
            self.results['checks']['mcp_server_mount'] = 'PASS'
            
            # Count available servers
            success, stdout, _ = self.run_command([
                'docker', 'exec', 'n8n', 'find', '/opt/mcp-servers',
                '-name', 'package.json', '-type', 'f'
            ])
            if success:
                server_count = len(stdout.strip().split('\n'))
                self.results['checks']['mcp_server_count'] = f'PASS ({server_count} servers)'
            else:
                self.results['checks']['mcp_server_count'] = 'FAIL'
        else:
            self.results['checks']['mcp_server_mount'] = 'FAIL'
            self.results['errors'].append("N8N cannot access MCP servers")
            
    def check_service_health(self):
        """Check health of all services"""
        print("Checking service health...")
        
        critical_services = [
            ('n8n', 5678),
            ('postgres', 5433),
            ('supabase-db', 5432),
            ('neo4j-knowledge', 7474),
            ('caddy', 80)
        ]
        
        for service, port in critical_services:
            success, _, _ = self.run_command(['docker', 'ps', '-q', '-f', f'name=^{service}$'])
            if success and _.strip():
                self.results['checks'][f'{service}_running'] = 'PASS'
            else:
                self.results['checks'][f'{service}_running'] = 'FAIL'
                self.results['errors'].append(f"{service} is not running")
                
    def check_caddy_configuration(self):
        """Validate Caddy configuration"""
        print("Checking Caddy configuration...")
        
        required_domains = [
            'n8n.vividwalls.blog',
            'supabase.vividwalls.blog',
            'studio.vividwalls.blog',
            'neo4j.vividwalls.blog',
            'wordpress.vividwalls.blog'
        ]
        
        success, stdout, _ = self.run_command(['cat', '/root/vivid_mas/Caddyfile'])
        if success:
            caddy_content = stdout
            missing_domains = []
            
            for domain in required_domains:
                if domain not in caddy_content:
                    missing_domains.append(domain)
                    
            if missing_domains:
                self.results['checks']['caddy_domains'] = 'FAIL'
                self.results['errors'].append(f"Missing domains in Caddyfile: {missing_domains}")
            else:
                self.results['checks']['caddy_domains'] = 'PASS'
        else:
            self.results['checks']['caddy_configuration'] = 'FAIL'
            self.results['errors'].append("Failed to read Caddyfile")
            
    def generate_report(self):
        """Generate validation report"""
        print("\n" + "="*60)
        print("MIGRATION VALIDATION REPORT")
        print("="*60)
        print(f"Timestamp: {self.results['timestamp']}")
        print("\nCheck Results:")
        print("-"*40)
        
        for check, result in self.results['checks'].items():
            status = "✓" if "PASS" in str(result) else "✗" if "FAIL" in str(result) else "⚠"
            print(f"{status} {check}: {result}")
            
        if self.results['errors']:
            print("\nErrors:")
            print("-"*40)
            for error in self.results['errors']:
                print(f"✗ {error}")
                
        if self.results['warnings']:
            print("\nWarnings:")
            print("-"*40)
            for warning in self.results['warnings']:
                print(f"⚠ {warning}")
                
        # Overall status
        total_checks = len(self.results['checks'])
        passed_checks = sum(1 for r in self.results['checks'].values() if "PASS" in str(r))
        
        print("\n" + "="*60)
        print(f"Overall: {passed_checks}/{total_checks} checks passed")
        
        if self.results['errors']:
            print("Status: FAILED - Critical issues found")
            return False
        elif self.results['warnings']:
            print("Status: PASSED WITH WARNINGS")
            return True
        else:
            print("Status: PASSED - All checks successful")
            return True
            
    def validate(self):
        """Run all validation checks"""
        self.check_encryption_key()
        self.check_network_configuration()
        self.check_database_connections()
        self.check_mcp_servers()
        self.check_service_health()
        self.check_caddy_configuration()
        
        # Save results to file
        with open(f'migration_validation_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json', 'w') as f:
            json.dump(self.results, f, indent=2)
            
        return self.generate_report()


if __name__ == "__main__":
    validator = MigrationValidator()
    success = validator.validate()
    sys.exit(0 if success else 1)