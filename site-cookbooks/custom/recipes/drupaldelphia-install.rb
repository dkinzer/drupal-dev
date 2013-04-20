# Cookbook Name:: custom
# Recipe:: bashrc
#
# Copyright 2013, Jenkins Law Library
#
# All rights reserved - Do Not Redistribute
#
# @file
# The drupal-cookbook only gets us so far because we tend to do things
# a litle differenlty.  Specifically, we deploy our project from a version 
# controlled sites folder. And, we have our own drupal profile.
#
# Therefore, after the drupal cookbook does its 'thang', we'll need to come in
# and finish the job by:
#
# 1. Cloning our sites folder into the drupal site.
# 2. Adding our custom config file.
# 3. Running our site phing task to rebuild the site (yeah, we do that).
#
include_recipe 'git'

drupal_dir     = node['drupal']['dir']
drupal_version = "d#{node['drupal']['version'][0..0]}"

db_database = node['drupal']['db']['database']
db_user     = node['drupal']['db']['user']
db_password = node['drupal']['db']['password']
db_host     = node['drupal']['db']['host']

drupaldelphia_user   = node['drupaldelphia']['user']
drupaldelphia_source = node['drupaldelphia']['source']['repo']
source_ref = node['drupaldelphia']['source']['ref']

# We need to delete the sites folder unles it's a repo.
directory "#{drupal_dir}/sites" do
  action :delete
  recursive true
  not_if { File.exists? "#{drupal_dir}/sites/.git" }
end 

# If the drupal site is owned by root it's that much harder to work with it.
directory drupal_dir do
  owner drupaldelphia_user
  group drupaldelphia_user
  mode 0755
  recursive true
end

# We'll need to wrap our ssh command in order to pull a private repo.
template "/home/#{drupaldelphia_user}/.ssh/ssh_wrapper.sh" do
  owner drupaldelphia_user
  group drupaldelphia_user
  source "ssh_wrapper.erb"
  mode "0700"
  variables 'key_path' => "/home/#{drupaldelphia_user}/.ssh/id_rsa"
end

# Clone our drupal sites folder.
git "#{drupal_dir}" do
  user       drupaldelphia_user
  repository drupaldelphia_source
  reference  source_ref
  action     :checkout
  ssh_wrapper "/home/#{drupaldelphia_user}/.ssh/ssh_wrapper.sh"

  enable_submodules true
  action :sync
end

# Add our custom config file.
template "#{drupal_dir}/sites/default/settings.php" do
  owner drupaldelphia_user
  group drupaldelphia_user
  source "#{drupal_version}.settings.php.erb"
  mode "0644"
  variables(
    'database' => db_database,
    'user'     => db_user,
    'password' => db_password,
    'host'     => db_host
  )
end

# The files directory needs to be writable by apache.
directory "#{drupal_dir}/sites/default/files" do
  owner drupal_user
  group 'apache'
  mode 0775
  recursive true
end

# Run the phing task to rebuild the site.
bash "Site-Rebuild" do
  cwd "#{drupal_dir}"
  user drupaldelphia_user
  code <<-EOF
    (phing reset-site)
  EOF
end

# Add ctags package for vim.
# (I should move this so a vim specific recipe.)
case node[:platform]
when "ubuntu"
  package "exuberant-ctags"
else
  package "ctags"
end

# Drupal linting requres that we link the Drupal standard.
bash "Site-Rebuild" do
  cwd "#{drupal_dir}/sites"
  code <<-EOF
    (ln -fvs #{drupal_dir}/sites/all/modules/contrib/coder/coder_sniffer/Drupal $(pear config-get php_dir)/PHP/CodeSniffer/Standards)
    cd $(pear config-get php_dir)/PHP/CodeSniffer/Standards
    chown #{drupaldelphia_user}:#{drupaldelphia_user} Drupal
  EOF
end

