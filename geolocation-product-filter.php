<?php
/**
 * Plugin Name: Custom Geolocation Product Filter
 * Description: Robustly hides [EU]/[US] products from SQL queries based on geolocation. Optimized for Cart compatibility.
 * Version: 2.4 - SAFE MODE
 * Author: Antigravity
 */

if (!defined('ABSPATH')) {
    exit;
}

/**
 * 1. SQL FILTER (The Heavy Hitter)
 * This hides the products from the Shop, Category pages, and Search results.
 */
add_filter('posts_where', 'custom_geo_filter_sql', 999, 2);

function custom_geo_filter_sql($where, $query)
{
    // Only run on frontend main queries
    if (is_admin() || !$query->is_main_query()) {
        return $where;
    }

    // SAFETY CHECK: NEVER run in Cart, Checkout, or during AJAX Add-to-Cart events
    if (is_cart() || is_checkout() || (defined('DOING_AJAX') && DOING_AJAX)) {
        return $where;
    }

    // Only apply to product lists (Shop, Categories, Tags, Search, Home)
    if (is_shop() || is_product_taxonomy() || is_search() || is_home() || is_front_page()) {

        global $wpdb;
        $country = custom_get_visitor_country();

        // EU Countries List
        $eu_countries = array(
            'AT',
            'BE',
            'BG',
            'HR',
            'CY',
            'CZ',
            'DK',
            'EE',
            'FI',
            'FR',
            'DE',
            'GR',
            'HU',
            'IE',
            'IT',
            'LV',
            'LT',
            'LU',
            'MT',
            'NL',
            'PL',
            'PT',
            'RO',
            'SK',
            'SI',
            'ES',
            'SE'
        );
        $is_eu = in_array($country, $eu_countries);

        if ($is_eu) {
            // Visitor is in EU -> Hide products with [US] in title
            $where .= " AND {$wpdb->posts}.post_title NOT LIKE '%[US]%'";
        } else {
            // Visitor is NOT in EU (US, etc) -> Hide products with [EU] in title
            $where .= " AND {$wpdb->posts}.post_title NOT LIKE '%[EU]%'";
        }
    }

    return $where;
}

/**
 * 2. VISIBILITY FILTER - PASS-THROUGH
 * We disable the individual visibility check to prevent WooCommerce from
 * removing items from the cart if they are "hidden".
 * The SQL filter above is sufficient for the user experience.
 */
add_filter('woocommerce_product_is_visible', 'custom_geo_filter_visibility', 10, 2);

function custom_geo_filter_visibility($visible, $product_id)
{
    return $visible;
}

/**
 * Helper: Get Country
 * Tries WooCommerce Geolocation first, then User Billing Address, defaults to US.
 */
function custom_get_visitor_country()
{
    // 1. Try WooCommerce Geolocation (Detected via updated wp-config)
    if (class_exists('WC_Geolocation')) {
        $location = WC_Geolocation::geolocate_ip();
        if (!empty($location['country'])) {
            return $location['country'];
        }
    }

    // 2. Fallback to Billing Country if logged in
    if (is_user_logged_in()) {
        $user = wp_get_current_user();
        if ($user->ID) {
            $billing_country = get_user_meta($user->ID, 'billing_country', true);
            if ($billing_country)
                return $billing_country;
        }
    }

    // 3. Default Fallback
    return 'US';
}

// Debug Helper (Admins Only) - Minimal footprint
add_action('wp_footer', 'custom_geo_debug_footer');
function custom_geo_debug_footer()
{
    if (current_user_can('manage_options') && isset($_GET['debug_geo'])) {
        $country = custom_get_visitor_country();
        echo "<div style='position:fixed;bottom:0;left:0;background:red;color:white;padding:5px;z-index:99999;font-size:12px;'>DEBUG: $country</div>";
    }
}
?>