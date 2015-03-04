#!/usr/bin/expect -f

# Marcelo Lopes
# marcelo.lopesousa@gmail.com
# 04/03/2015
# 
# Automatiza a execucao do ansible

set fhost [lrange $argv 0 0]
set senha [lrange $argv 1 1]
set comando [lindex $argv 2 ]

spawn ansible -i "$fhost" * -s -k -m shell -a "$comando"
expect {
        "SSH password:" {
                send "$senha\r"
                expect {
                        "(yes/no)" {
                                send "yes\r"
                        }
                }
        }
}

expect eof
