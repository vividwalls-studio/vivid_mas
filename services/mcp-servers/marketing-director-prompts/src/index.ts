#!/usr/bin/env node
import "dotenv/config"
import { createServer } from "@modelcontextprotocol/sdk"
import * as prompts from "./prompts"

const PORT = process.env.PORT || 3004
createServer({ prompts: Object.values(prompts), port: +PORT })
  .then(() => console.log(`Marketing Director Prompt server listening on port ${PORT}`))
  .catch(err => console.error(err))
