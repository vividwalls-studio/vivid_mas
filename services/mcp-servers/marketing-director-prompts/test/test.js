#!/usr/bin/env node
require('dotenv').config()
const assert = require('assert')
const prompts = require('../dist/prompts')

// Ensure all prompts are defined and have name & template
for (const [key, prompt] of Object.entries(prompts)) {
  assert(prompt.name, `Prompt ${key} missing name`)
  assert(prompt.template, `Prompt ${key} missing template`)
}
console.log('✅ marketing-director-prompts export shape validated')
