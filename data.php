<?php
$data = array();

$data['wp_title'] = wp_title('', false);
$data['tagline'] = get_bloginfo('tagline');
$data['theme_dir'] = get_template_directory_uri();
$data['home_url'] = esc_url( home_url( '/' ) );
$data['blog_title'] = get_bloginfo();

$data['styles'] = array(
	'screen' => get_template_directory_uri().'/lib/css/screen.css'
);

$data['scripts'] = array(
	'vendor' => $data['theme_dir'].'/lib/js/vendor.min.js',
	'main' => $data['theme_dir'].'/lib/js/main.min.js',
);

$data['imports'] = array(
        $data['theme_dir']."/lib/elements/re-style.html",
        $data['theme_dir']."/lib/elements/re-share.html",
);

$data['pages'] = get_pages();
$data['categories'] = get_categories('show_count=0&title_li=&hide_empty=0&exclude=1');

// To compensate for Wordpress not providing a url for each post
foreach ( $data['pages'] as $page ) {
  $page->permalink = get_permalink($page->ID);
}

// To compensate for Wordpress not providing a url for each category
foreach ( $data['categories'] as $category ) {
  $category->link = get_category_link( $category->term_id );
}

return $data;
?>
