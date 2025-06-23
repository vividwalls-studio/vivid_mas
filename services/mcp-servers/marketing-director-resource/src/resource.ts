import { ResourceDefinition } from '@modelcontextprotocol/sdk'

export const marketingDirectorResource: ResourceDefinition = {
  name: 'marketing-director',
  description: "Returns Marketing Director agent's tasks and domain knowledge from Supabase.",
  async read(context) {
    // dynamically require Supabase client to avoid import at module load
    const { createClient } = require('@supabase/supabase-js')
    const supabaseUrl = process.env.SUPABASE_URL!
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY!
    const supabase = createClient(supabaseUrl, supabaseKey)

    const agentId = context.parameters.agentId as string
    const { data, error } = await supabase
      .from('agent_domain_knowledge')
      .select('task_list, knowledge_json')
      .eq('agent_id', agentId)
      .single()

    if (error) throw error
    return {
      tasks: data.task_list,
      knowledge: data.knowledge_json
    }
  }
}
