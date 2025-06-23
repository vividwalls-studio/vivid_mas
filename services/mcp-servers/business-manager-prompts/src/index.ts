import "dotenv/config"
import { createServer } from "@modelcontextprotocol/sdk"
import * as prompts from "./prompts"

const PORT = process.env.PORT || 3002
createServer({ prompts: Object.values(prompts), port: +PORT })
  .then(server => console.log(`Business Manager Prompt server listening on port ${PORT}`))
  .catch(err => console.error(err))
