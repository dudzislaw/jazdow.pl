<?php

function re_setup()
{
	// Retrieve the directory for the localization files
	$lang_dir = get_template_directory().'/language';
	load_theme_textdomain('re', $lang_dir);
	show_admin_bar(false);
	add_theme_support('post-thumbnails');
	add_editor_style('lib/css/style-editor.css');
	add_theme_support('automatic-feed-links');
	// Remove some wordpress junk from the head
	remove_action('wp_head', 'wlwmanifest_link');
	remove_action('wp_head', 'rsd_link');

	// Add custom roles
	// remove_role('member');

	$member_caps = array(
		'level_0' => true,
		'read' => true,
		'edit_posts' => true,
		'upload_files' => true,
		'publish_posts' => false,
	);
	add_role('member', 're:Kreators member', $member_caps);
}

add_action('after_setup_theme', 're_setup');

// Register scripts:
function re_scripts()
{
	// Then register your scripts
	wp_register_script('vendor', get_template_directory_uri().'/lib/js/vendor.min.js');
	wp_register_script('main', get_template_directory_uri().'/lib/js/main.min.js');
	wp_enqueue_script('vendor','main');
	// Localize init, and replace re_Ajax with the link to the admin-ajax.php
   wp_localize_script('main', 're_Ajax', array('ajaxurl' => admin_url('admin-ajax.php')));
}
add_action('wp_enqueue_scripts', 're_scripts');

// Register stylesheets:
function re_styles()
{
	wp_register_style('style', get_template_directory_uri().'/lib/css/screen.css', array(), '1.0', 'screen');
	wp_enqueue_style(array('style'));
}
add_action('wp_enqueue_scripts', 're_styles');

// Dequeue SCRIPTS from the front end
function re_dequeue_front_scripts()
{
	if (!is_admin()) {
		wp_dequeue_script('jquery');
		wp_dequeue_script('wptoolset-field-date');
		wp_dequeue_script('jquery-ui-datepicker-local-pl');
	}
}
add_filter('wp_enqueue_scripts', 're_dequeue_front_scripts', 11);

// Dequeue STYLES from the front end
function re_dequeue_front_styles()
{
	if (!is_admin()) {
		wp_dequeue_style('boxes');
		wp_dequeue_style('wptoolset-field-datepicker');
		wp_dequeue_style('sharedaddy');
	}
}
add_filter('wp_enqueue_scripts', 're_dequeue_front_styles', 11);

// Register menus:
register_nav_menus(
array(
	'main-menu' => 'Main Menu',
	'footer-menu' => 'Footer Menu',
	)
);

// Add custom image sizes
if (function_exists('add_image_size')) {
	add_image_size('teaser', 800, 400, true, array('center', 'center'));
	add_image_size('icon', 160, 160, true, array('center', 'center'));
	add_image_size('blog', 800, 600, false);
	add_image_size('showcase', 500, 300, true);
	add_image_size('marker', 150, 75, true);
}

// ADD JETPACK PUBLICIZE SUPPROT FOR CUSTOM POST TYPES
add_action('init', 're_extend_publicize');
function re_extend_publicize()
{
	add_post_type_support('sign', 'publicize');
}

// Excerpt length and [...]
function re_excerpt_length($length)
{
	return 40;
}
add_filter('excerpt_length', 're_excerpt_length', 999);

function re_excerpt_more($more)
{
	return '...';
}
add_filter('excerpt_more', 're_excerpt_more');

// Replaces post search in WP_Query by exact keyword, with 'LIKE' keyword
function posts_like_title($where, &$wp_query)
{
	global $wpdb;
	if ($title_like = $wp_query->get('title_like')) {
		$where .= ' AND '.$wpdb->posts.'.post_title LIKE \''.esc_sql($wpdb->esc_like($title_like)).'%\'';
	}

	return $where;
}
add_filter('posts_where', 'posts_like_title', 10, 2);

// Remove admin color scheme

function admin_color_scheme()
{
	global $_wp_admin_css_colors;
	$_wp_admin_css_colors = 0;
}
add_action('admin_head', 'admin_color_scheme');

// Just in case, set locale
setlocale(LC_ALL, get_locale());
