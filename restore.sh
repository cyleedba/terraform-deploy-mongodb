#!/bin/bash
backupath='/mongodb/data/backup/'
nowtime=$(date +%Y%m%d)
port=27017
server=$(hostname)
username=restore
password=qwe123
## restore database file



sudo mongorestore -u $username -p $password --authenticationDatabase "admin" --noIndexRestore --dir $backupath

echo "============== restore end ${nowtime} =============="
