#
# Cookbook Name:: custom
# Recipe:: php
#
# Copyright 2013, Jenkins Law Library
#
# All rights reserved - Do Not Redistribute
#

# When we compile php from source we enable modules that then don't
# need to be reloaded. 

# We need install httpd-devel in order to properly compile php_mod.
package "httpd-devel" do
  action :install
end

include_recipe %w{ php }

php_modules = %w{curl dom fileinfo gd json mysql mysqli phar sqlite3 xmlreader xmlwriter zip pdo_sqlite pdo pdo_mysql json}

php_modules.each do |m|
  file "/etc/php.d/#{m}.ini" do
    action :delete
  end
end

# Fix php not available in /usr/bin
link "/usr/bin/php" do
  to "/usr/local/bin/php"
end

# Clean up php sources to avoid errors on cook.
directory "/tmp/chef-solo/php-#{node['php']['version']}" do
  action :delete
  recursive true
end




