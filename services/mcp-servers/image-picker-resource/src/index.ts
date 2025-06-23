import "dotenv/config"
import { createServer } from "@modelcontextprotocol/sdk"
import { imagePicker } from "./resource"

const PORT = process.env.PORT || 3007
createServer({ resources: [imagePicker], port: +PORT })
  .then(() => console.log(`Image Picker Resource server listening on port ${PORT}`))
  .catch(err => console.error(err))
