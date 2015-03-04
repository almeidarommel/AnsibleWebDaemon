Daemon responsável por consumir lotes no redis, mensagens criadas pela app AnsibleWeb, e executalas usando o script ansible.py

Criar arquivo config.yml no diretório root do AnsibleWebDaemon

redis:
 fila: "fila::ansible"

ansible:
 usuario: "username"
 senha: "password"

webservice:
 master: "dominio.com"

Executar AnsibleWebDaemon

# ruby daemon.rb start
