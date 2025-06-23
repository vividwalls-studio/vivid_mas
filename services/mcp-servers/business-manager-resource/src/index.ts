import "dotenv/config"
import { createServer } from "@modelcontextprotocol/sdk"
import { businessManager } from "./resource"

const PORT = process.env.PORT || 3001
createServer({ resources: [businessManager], port: +PORT })
  .then(server => {
    console.log(`Business Manager Resource server listening on port ${PORT}`)
  })
  .catch(err => console.error(err))
