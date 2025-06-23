#!/usr/bin/env node
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

// Load environment variables
dotenv.config();

const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_KEY = process.env.SUPABASE_KEY || '';
const SUPABASE_DB_URL = process.env.SUPABASE_DB_URL || '';

console.log('Testing Supabase connection...');
console.log('SUPABASE_URL:', SUPABASE_URL);
console.log('SUPABASE_KEY available:', !!SUPABASE_KEY);
console.log('SUPABASE_DB_URL available:', !!SUPABASE_DB_URL);

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing required environment variables!');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function testConnection() {
  try {
    // Test basic connection
    const { data, error } = await supabase
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public')
      .limit(5);

    if (error) {
      console.error('Connection test failed:', error);
    } else {
      console.log('Connection successful!');
      console.log('Found tables:', data?.map(t => t.table_name).join(', '));
    }

    // Test SQL execution capability
    if (SUPABASE_DB_URL) {
      console.log('\nSQL execution capability: AVAILABLE');
      console.log('You can use the execute-sql tool to run raw SQL queries.');
    } else {
      console.log('\nSQL execution capability: NOT AVAILABLE');
      console.log('Set SUPABASE_DB_URL to enable SQL execution.');
    }
  } catch (error) {
    console.error('Test failed:', error);
  }
}

testConnection();