#!/usr/bin/env node
import dotenv from 'dotenv'
dotenv.config()
import assert from 'assert'
import { createServer } from '../dist/server.js'

assert(createServer, 'Missing createServer export')
assert(typeof createServer === 'function', 'createServer is not a function')

const server = createServer()
assert(server.tool, 'Server missing tool method')
assert(typeof server.tool === 'function', 'server.tool is not a function')
console.log('✅ creative-director-prompts export shape validated')
