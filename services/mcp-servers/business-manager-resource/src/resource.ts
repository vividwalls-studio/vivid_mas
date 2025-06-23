import { createClient } from '@supabase/supabase-js'
import { ResourceDefinition } from '@modelcontextprotocol/sdk'

export const businessManager: ResourceDefinition = {
  name: 'business-manager',
  description: "Returns Business Manager agent's tasks and domain knowledge from Supabase.",
  async read(context) {
    // create Supabase client at runtime
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
