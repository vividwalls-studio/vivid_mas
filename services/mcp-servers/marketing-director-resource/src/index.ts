import "dotenv/config"
import { createServer } from "@modelcontextprotocol/sdk"
import { marketingDirectorResource } from "./resource"

const PORT = process.env.PORT || 3003
createServer({ resources: [marketingDirectorResource], port: +PORT })
  .then(() => console.log(`Marketing Director Resource server listening on port ${PORT}`))
  .catch(err => console.error(err))
