import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { createClient } from "@supabase/supabase-js";

// Initialize Supabase client
const supabaseUrl = process.env.SUPABASE_URL!;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;
const supabase = createClient(supabaseUrl, supabaseKey);

export function createServer(): McpServer {
  const server = new McpServer({
    name: "marketing-research-resource",
    version: "0.1.0",
  });

  server.tool(
    "get_weather",
    "Get weather info for a given city.",
    {
      city: z.string().describe("city name"),
    },
    async ({ city }) => {
      if (!city) {
        throw new Error("city name is required.");
      }

      const weather = {
        city: city,
        temperature: Math.floor(Math.random() * 30),
        condition: "Sunny",
      };

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(weather, null, 2),
          },
        ],
      };
    },
  );

  // Tool: Fetch newsletter templates
  server.tool(
    "get_newsletters",
    "Get newsletter templates by type",
    { templateType: z.string().describe("newsletter template type") },
    async ({ templateType }) => {
      const { data, error } = await supabase
        .from("newsletters")
        .select("id, title, body_template")
        .eq("template_type", templateType);
      if (error) throw error;
      return { content: [{ type: "json", data }] };
    },
  );

  // Tool: Fetch market research report
  server.tool(
    "get_market_report",
    "Get market research report by report id",
    { reportId: z.string().describe("report id") },
    async ({ reportId }) => {
      const { data, error } = await supabase
        .from("market_research_reports")
        .select("report_json")
        .eq("report_id", reportId)
        .single();
      if (error) throw error;
      return { content: [{ type: "json", data: data.report_json }] };
    },
  );

  return server;
}
