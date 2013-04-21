require 'net/scp'
require 'fileutils'

task :default => ['build']
node = '10.10.10.2'
user = 'vagrant'
password = 'vagrant'
id_rsa = "#{ENV['HOME']}/.ssh/id_rsa"
gitHub_rsa = "#{ENV['HOME']}/.ssh/gitHub_rsa"
  
task 'build' do
end

task 'keys' do
  if File.exist? gitHub_rsa
    moveKeys gitHub_rsa, node, user, password
  elsif okayToMoveKeys? id_rsa
    copyKeys id_rsa gitHub_rsa
    moveKeys gitHub_rs, node, user, password
  end
end

def okayToMoveKeys? keys
  if keysEncrypted? keys
    puts "Please  Generate a non encrypted key pair and try again."
    FALSE
  else 
    ask "We found a key pair. Is it OK to move this pair to the vagrant box?"
  end
end

def copyKeys from, to
  puts "Making a copy of the rsa keys keys."
  FileUtils.cp(from, to)
  FileUtils.cp("#{from}.pub", "#{to}.pub")
end

def keysEncrypted? key
  return open(key).grep(/ENCRYPTED/)
end

def moveKeys keys, node, user, password
  puts "Moving your local gitHub ssh keys to the box."
  puts "Please make sure that these keys have been authenticated with GitHub."
  Net::SCP.start(node, user, :password => password ) do |scp|
    scp.upload! keys, "/home/#{user}/.ssh/id_rsa"
    scp.upload! "#{keys}.pub", "/home/#{user}/.ssh/id_rsa.pub"
  end 
end

def ask question
  STDOUT.puts "#{question} [y/n]"
  input = STDIN.gets.strip
  if input == 'y'
    TRUE
  else
    FALSE
  end
end
