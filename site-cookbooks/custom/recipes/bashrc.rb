#
# Cookbook Name:: custom
# Recipe:: bashrc
#
# Copyright 2013, Jenkins Law Library
#
# All rights reserved - Do Not Redistribute
#

# Add default .bashrc file.
template "/etc/profile.d/bashrc.sh" do
  source 'bashrc.erb'
  mode 00644
  variables(
    'db_su_pw' => node['mysql']['server_root_password'],
    'account_name' => node['drupal']['site']['admin'],
    'account_pass' => node['drupal']['site']['pass']
  )
end

