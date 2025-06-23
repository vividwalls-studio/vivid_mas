// Validate marketingDirectorResource export shape
require('dotenv').config()
const assert = require('assert')
const { marketingDirectorResource } = require('../dist/resource')

assert(marketingDirectorResource, 'Missing marketingDirectorResource export')
assert(typeof marketingDirectorResource.read === 'function', 'marketingDirectorResource.read is not a function')
console.log('✅ marketing-director-resource export shape validated')
