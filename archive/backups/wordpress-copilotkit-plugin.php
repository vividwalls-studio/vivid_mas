<?php
/**
 * Plugin Name: VividWalls CopilotKit Integration
 * Description: Embeds CopilotKit AI assistant for VividWalls art recommendations
 * Version: 1.0.0
 * Author: VividWalls
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class VividWallsCopilotKit {
    
    public function __construct() {
        add_action('wp_enqueue_scripts', array($this, 'enqueue_scripts'));
        add_action('wp_footer', array($this, 'render_copilot_widget'));
        add_shortcode('vividwalls_copilot', array($this, 'copilot_shortcode'));
        add_action('wp_ajax_copilot_proxy', array($this, 'handle_copilot_proxy'));
        add_action('wp_ajax_nopriv_copilot_proxy', array($this, 'handle_copilot_proxy'));
    }
    
    /**
     * Enqueue necessary scripts and styles
     */
    public function enqueue_scripts() {
        // React and ReactDOM from CDN
        wp_enqueue_script('react', 'https://unpkg.com/react@18/umd/react.production.min.js', array(), '18.0.0', true);
        wp_enqueue_script('react-dom', 'https://unpkg.com/react-dom@18/umd/react-dom.production.min.js', array('react'), '18.0.0', true);
        
        // CopilotKit from CDN (if available) or custom build
        wp_enqueue_script('copilotkit-core', 'https://unpkg.com/@copilotkit/react-core@latest/dist/index.js', array('react'), '1.0.0', true);
        wp_enqueue_script('copilotkit-ui', 'https://unpkg.com/@copilotkit/react-ui@latest/dist/index.js', array('copilotkit-core'), '1.0.0', true);
        
        // Custom CopilotKit integration script
        wp_enqueue_script('vividwalls-copilot', plugin_dir_url(__FILE__) . 'assets/vividwalls-copilot.js', array('copilotkit-ui'), '1.0.0', true);
        
        // Localize script with WordPress data
        wp_localize_script('vividwalls-copilot', 'vividwalls_ajax', array(
            'ajax_url' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('vividwalls_copilot_nonce'),
            'n8n_endpoint' => get_option('vividwalls_n8n_endpoint', 'https://n8n.vividwalls.blog/webhook/vividwalls-copilot'),
            'api_key' => get_option('vividwalls_api_key', '')
        ));
        
        // Custom styles
        wp_enqueue_style('vividwalls-copilot-style', plugin_dir_url(__FILE__) . 'assets/vividwalls-copilot.css', array(), '1.0.0');
    }
    
    /**
     * Render the CopilotKit widget in footer
     */
    public function render_copilot_widget() {
        if (is_admin()) return;
        
        echo '<div id="vividwalls-copilot-container"></div>';
    }
    
    /**
     * Shortcode for embedding CopilotKit in specific pages/posts
     */
    public function copilot_shortcode($atts) {
        $atts = shortcode_atts(array(
            'mode' => 'chat', // chat, sidebar, popup
            'trigger_text' => 'Ask about art recommendations',
            'position' => 'bottom-right'
        ), $atts);
        
        $unique_id = 'vividwalls-copilot-' . uniqid();
        
        return sprintf(
            '<div id="%s" class="vividwalls-copilot-embed" data-mode="%s" data-trigger="%s" data-position="%s"></div>',
            $unique_id,
            esc_attr($atts['mode']),
            esc_attr($atts['trigger_text']),
            esc_attr($atts['position'])
        );
    }
    
    /**
     * Handle AJAX proxy to n8n workflow
     */
    public function handle_copilot_proxy() {
        // Verify nonce
        if (!wp_verify_nonce($_POST['nonce'], 'vividwalls_copilot_nonce')) {
            wp_die('Security check failed');
        }
        
        $chat_input = sanitize_text_field($_POST['chatInput']);
        $session_id = sanitize_text_field($_POST['sessionId']);
        $image_data = isset($_POST['imageData']) ? $_POST['imageData'] : null;
        
        // Prepare data for n8n workflow
        $payload = array(
            'chatInput' => $chat_input,
            'sessionId' => $session_id,
            'imageData' => $image_data,
            'source' => 'wordpress',
            'page_url' => $_POST['page_url'],
            'user_agent' => $_SERVER['HTTP_USER_AGENT']
        );
        
        // Send to n8n workflow
        $n8n_endpoint = get_option('vividwalls_n8n_endpoint');
        $response = wp_remote_post($n8n_endpoint, array(
            'body' => json_encode($payload),
            'headers' => array(
                'Content-Type' => 'application/json',
            ),
            'timeout' => 30
        ));
        
        if (is_wp_error($response)) {
            wp_send_json_error('Failed to connect to AI service');
        }
        
        $body = wp_remote_retrieve_body($response);
        $data = json_decode($body, true);
        
        wp_send_json_success($data);
    }
}

// Initialize the plugin
new VividWallsCopilotKit();

/**
 * Add admin menu for plugin settings
 */
add_action('admin_menu', 'vividwalls_copilot_admin_menu');

function vividwalls_copilot_admin_menu() {
    add_options_page(
        'VividWalls CopilotKit Settings',
        'VividWalls AI',
        'manage_options',
        'vividwalls-copilot',
        'vividwalls_copilot_admin_page'
    );
}

function vividwalls_copilot_admin_page() {
    if (isset($_POST['submit'])) {
        update_option('vividwalls_n8n_endpoint', sanitize_url($_POST['n8n_endpoint']));
        update_option('vividwalls_api_key', sanitize_text_field($_POST['api_key']));
        echo '<div class="notice notice-success"><p>Settings saved!</p></div>';
    }
    
    $n8n_endpoint = get_option('vividwalls_n8n_endpoint', '');
    $api_key = get_option('vividwalls_api_key', '');
    ?>
    <div class="wrap">
        <h1>VividWalls CopilotKit Settings</h1>
        <form method="post" action="">
            <table class="form-table">
                <tr>
                    <th scope="row">n8n Webhook Endpoint</th>
                    <td>
                        <input type="url" name="n8n_endpoint" value="<?php echo esc_attr($n8n_endpoint); ?>" class="regular-text" />
                        <p class="description">Enter your n8n workflow webhook URL</p>
                    </td>
                </tr>
                <tr>
                    <th scope="row">API Key</th>
                    <td>
                        <input type="password" name="api_key" value="<?php echo esc_attr($api_key); ?>" class="regular-text" />
                        <p class="description">Optional API key for authentication</p>
                    </td>
                </tr>
            </table>
            <?php submit_button(); ?>
        </form>
        
        <h2>Usage</h2>
        <p>Use the shortcode <code>[vividwalls_copilot]</code> to embed the AI assistant anywhere on your site.</p>
        <p>Available shortcode parameters:</p>
        <ul>
            <li><code>mode</code>: chat, sidebar, or popup (default: chat)</li>
            <li><code>trigger_text</code>: Custom button text</li>
            <li><code>position</code>: bottom-right, bottom-left, etc.</li>
        </ul>
        <p>Example: <code>[vividwalls_copilot mode="popup" trigger_text="Get Art Recommendations"]</code></p>
    </div>
    <?php
} 