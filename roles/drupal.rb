name 'drupal'
description 'Drupal Role'

override_attributes(
  "vim" => {
    "install_method" => 'source',
  },
  'drupal' => {
    'site' => {
      'admin' => 'admin',
      'pass' => 'buddy',
     }
  },
)

run_list(
  "role[base]",
  "recipe[phantomjs]",
  "recipe[drush]",
  "recipe[casperjs]",
  "recipe[phing]",
  "recipe[custom::bashrc]",
  "recipe[custom::drupaldelphia-install]",
)
