name "base"
description "Base role"


override_attributes(
  "mysql" => {
    "server_root_password" => "iloverandompasswordsbutthiswilldo",
    "server_repl_password" => "iloverandompasswordsbutthiswilldo",
    "server_debian_password" => "iloverandompasswordsbutthiswilldo"
  },
  "drupal" => {
    "db" => {"password" => "drupalpass"},
    "dir" => "/var/www/html/drupaldelphia",
  },
  "drush" => {
    "install_method" => "git",
    "install_dir" => "/usr/local/src/drush",
    "version" => "8.x-6.x",
  },
  "hosts" => {
    "localhost_aliases" => ["cdb.dev", "cdb-dev", "localhost"]
  },
  'php' => {
    'version' => '5.3.10',
  },
)

default_attributes(
  "apache2" => {
    "listen_ports" => ["80", "443"]
  }
)

run_list(
  "role[apache2]",
  "role[memcached]",
  "recipe[vim]"
)

