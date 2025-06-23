// CommonJS imports and env loading
require('dotenv').config()
const assert = require('assert')
const { businessManager } = require('../dist/resource')

// Validate the ResourceDefinition shape
assert(businessManager, 'Missing businessManager export')
assert(typeof businessManager.read === 'function', 'businessManager.read is not a function')
console.log('✅ business-manager-resource export shape validated')
