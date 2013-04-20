require 'net/scp'

task :default => ['build']
node = '10.10.10.2'
user = 'vagrant'
password = 'vagrant'
  
task 'build' do
end

task 'keys' do
  puts "Moving your local ssh keys to the box."
  Net::SCP.start(node, user, :password => password ) do |scp|
    scp.upload! "#{ENV['HOME']}/.ssh/id_rsa", "/home/#{user}/.ssh/id_rsa"
    scp.upload! "#{ENV['HOME']}/.ssh/id_rsa.pub", "/home/#{user}/.ssh/id_rsa.pub"
  end
end


