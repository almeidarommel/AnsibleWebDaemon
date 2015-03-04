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
                    "descricao": "servidor01",
                    "ip": "10.0.0.1",
                    "porta": "22",
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

