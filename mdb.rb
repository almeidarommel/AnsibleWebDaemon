# Marcelo Lopes
# marcelo.lopesousa@gmail.com
# 04/03/2015
#
# Daemon responsál por consumir lotes no redis, mensagens criadas pela app A
# AnsibleWeb, e executalas usando o script ansible.py

require 'yaml'
require 'daemons'
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib/mdb')

config = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'config.yml'))

Daemons.run_proc('') do
  loop do
  	MDB::main(config)
  end
end
