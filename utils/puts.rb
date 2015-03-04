require 'rubygems'
require 'redis'
require 'json'

r = Redis.new

ob = %{

{

    "id": "20152214148884",
    "comando": "uptime",
    "estado": "novo",
    "data": "2015-03-02 14:14:07",
    "grupos": [
        {
            "id": "111",
            "descricao": "grupo01",
            "dominio": "dominio",
            "servidores": [
                {
                    "id": "111",
                    "descricao": "sd2jvd21",
                    "ip": "172.30.121.140",
                    "porta": "893",
                    "dominio": "",
                    "estado": "novo",
                    "resposta": ""
                }
            ]
        }
    ]

}

}
r.rpush("fila::ansible",ob)

