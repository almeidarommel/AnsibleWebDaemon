#!/bin/bash

# Marcelo Lopes
# marcelo.lopesousa@gmail.com
# 04/03/2015
#
# Automatiza a execucao do ansible e elimina dados 
# sem valor para a aplicacao no output da execucao
# do script ansible

$(dirname $0)/bin.inc "$1" "$2" "$3" 2> /dev/null |egrep -v '(spawn ansible|SSH password:|success)'
