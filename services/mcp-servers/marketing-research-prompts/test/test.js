#!/usr/bin/env node
require('dotenv').config()
const assert = require('assert')
const prompts = require('../dist/prompts.js')

// Validate prompt exports
const keys = [
  'marketingResearchSystem',
  'getMarketReportPrompt',
  'getNewsletterTemplatesPrompt',
  'summarizeReportPrompt'
]
for (const key of keys) {
  const p = prompts[key]
  assert(p, `Missing prompt: ${key}`)
  assert(typeof p.name === 'string', `${key} missing name`)
  assert(typeof p.template === 'string', `${key} missing template`)
}
console.log('✅ marketing-research-prompts export shape validated')
