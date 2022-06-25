#!/bin/bash
nowtime=$(date +%Y%m%d)
port=27017
server=$(hostname)
username=root
password=qwe123
filename=mongostat_output

sudo mongo $server:$port/admin -u $username -p $password --quiet --eval "db.getCollectionNames().forEach(function (n) { var s = db[n].stats(); print(s['ns'] + ',' + s['size'] + ',' + s['count'] + s['avgObjSize'] + ',' + ',' + s['storageSize']) })" | sort --numeric-sort --reverse >> $filename.csv