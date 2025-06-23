// Load env and dependencies
require('dotenv').config()
const assert = require('assert')

// Import all prompts
const prompts = require('../dist/prompts')

// Required prompt keys
const keys = [
  'businessManagerSystem',
  'coordinateAgentWorkflow',
  'generateStakeholderReport'
]

keys.forEach(key => {
  const prompt = prompts[key]
  assert(prompt, `Missing prompt export: ${key}`)
  assert(typeof prompt.name === 'string', `Prompt ${key} missing name`)
  assert(typeof prompt.template === 'string', `Prompt ${key} missing template`)
})

console.log('✅ business-manager-prompts export shape validated')
