#!/bin/bash
# Database credentials
user="root"
password="qwe123"
#port=27017
timestamp=$(date)
server=$(hostname)

Slavelog=`mongo $server:27017/admin -u $user -p $password --eval 'db.printSlaveReplicationInfo()' | grep 'behind' | awk 'BEGIN { FS = "behind" } { print $1 }' | head -n1 | awk '{print $1}'`



if [ $Slavelog -gt 100 ]
then
echo "Hi Team,">> /tmp/lag.txt
echo "Replication Lag is $SlaveLag hr(s)" on $server at $timestamp  >> /tmp/lag.txt
#mail -s " MongoDB Replication Lag on $server"  -S smtp=smtp://smtp.mailserver.com -S from=alert@yourmail.com  to-recievemail@domain.com  < /tmp/lag.txt
else
echo "Everything is fine"
fi