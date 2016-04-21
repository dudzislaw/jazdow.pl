<?php
$compiler = include 'compiler.php';
$data = include 'data.php';

$data['posts'] = array();

if ( have_posts() ):

  while ( have_posts() ): the_post();

    array_push($data['posts'], array(
      'href' => get_permalink(),
      'title' => get_the_title(),
      'tldr' => get_the_excerpt()
    ));

  endwhile;

  $data['next_posts_link'] = get_next_posts_link('Older');
  $data['previous_posts_link'] = get_previous_posts_link('Newer');

endif;

echo $compiler->render(get_template_directory() . '/_views/index.jade', $data);
?>
