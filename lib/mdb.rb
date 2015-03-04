# Marcelo Lopes
# marcelo.lopesousa@gmail.com
# 04/03/2015
#
# Daemon responsál por consumir lotes no redis, mensagens criadas pela app
# AnsibleWeb, e executalas usando o script ansible.py

module MDB
	extend self

	def alert(msg)
		puts "#{Time.new} - #{msg}"
	end

	def parseYAML(config)
		if config["ansible"]["usuario"].nil? then MDB::alert 'Error: ["ansible"]["usuario"] Not found in config.yml !!!'; exit; end
		if config["ansible"]["senha"].nil? then MDB::alert 'Error: ["ansible"]["senha"] Not found in config.yml !!!'; exit; end
		if config["redis"]["fila"].nil? then MDB::alert 'Error: ["redis"]["fila"] Not found in config.yml !!!'; exit; end
		if config["webservice"]["master"].nil? then MDB::alert 'Error: ["webservice"]["master"] Not found in config.yml !!!'; exit; end
        end

	def ansible(lote)
		require 'rubygems'
		require 'tempfile'

		begin
			@comando = lote["comando"]
			@estado = lote["estado"]
			grupos = lote["grupos"]

			grupos.each do |grupo|
				@grupoDescricao = grupo["descricao"]
				@grupoDominio = grupo["dominio"]
				servidores = grupo["servidores"]
				servidores.each do |servidor|
					@servidorId = servidor["id"]
					@servidorIp = servidor["ip"]
					@servidorPorta = servidor["porta"]
					@servidorDominio = servidor["dominio"]
				end
			end
			#MDB::alert "Starting lote processing. Lote: #{lote}"			
		rescue
			MDB::alert "Error: on lote format !!!"
		end

		if @servidorDominio == "" && @grupoDominio == "" then
                	@credenciais = @usuarioSSH
                else
                	if @servidorDominio == "" then
                        	@credenciais = @grupoDominio + '\\\\' + @usuarioSSH
                        else
                        	@credenciais = @servidorDominio + '\\\\' + @usuarioSSH
                        end
                end

		begin
                	inventoryFile = Tempfile.new('inventory')
               		inventoryFile.write "#{@servidorIp}:#{@servidorPorta} ansible_ssh_user=#{@credenciais}"
                	inventoryFile.close
                	@file = inventoryFile.path
		rescue
			MDB::alert "Error: creating file !!!"
		end


		begin
                	@bin = File.join(File.expand_path(File.dirname(__FILE__)), '../bin/bin.sh')
                	@retorno = %x["#{@bin}" "#{@file}" "#{@senhaSSH}" "#{@comando}" ]
			puts @retorno
		rescue
			 MDB::alert "Error: when running lote !!!"
		end

                inventoryFile.unlink
	end
  
	def main(config)
		require 'rubygems'
		require 'redis'
		require 'json'
		require 'yaml'
		
		MDB::parseYAML(config)

		begin
			r = Redis.new
			msg = r.blpop(config["redis"]["fila"], :timeout => 0)
			lote = JSON.parse(msg[1])
		rescue
			MDB::alert "Error: at connect to redis !!!"
			sleep 3
		end

		@usuarioSSH = config["ansible"]["usuario"]
		@senhaSSH = config["ansible"]["senha"]
		MDB::ansible(lote)
	end
end
