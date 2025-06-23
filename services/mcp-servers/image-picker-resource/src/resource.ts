import { createClient } from '@supabase/supabase-js'
import { ResourceDefinition } from '@modelcontextprotocol/sdk'

export const imagePicker: ResourceDefinition = {
  name: 'image-picker',
  description: "Select product images by topic, style, color and theme.",
  async read(context) {
    const { topic, style, color, theme } = context.parameters
    const supabaseUrl = process.env.SUPABASE_URL!
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY!
    const supabase = createClient(supabaseUrl, supabaseKey)

    // Query for images matching criteria
    const { data, error } = await supabase
      .from('product_images')
      .select('id, url, metadata')
      .ilike('metadata->>topic', `%${topic}%`)
      .ilike('metadata->>style', `%${style}%`)
      .ilike('metadata->>color', `%${color}%`)
      .ilike('metadata->>theme', `%${theme}%`)
      .limit(5)
    if (error) throw error

    return data.map(img => ({
      type: 'image',
      uri: img.url,
      resource: { text: img.metadata.description || '', uri: img.url }
    }))
  }
}
