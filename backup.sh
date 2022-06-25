#!/bin/bash
targetpath='/mongodb/data/backup'
nowtime=$(date +%Y%m%d)
port=27017
server=$(hostname)
username=dbackup
password=qwe123
# keep backup day
days=15

## backup database file
start()
{
  sudo mongodump --host $server:$port -u $username -p $password --out ${targetpath}
}
execute()
{
  start
  if [ $? -eq 0 ]
  then
    echo "back successfully!"
  else
    echo "back failure!"
  fi
}
execute

# delete older than 15 days backup file
sudo find $targetpath/ -mtime +$days -delete

echo "============== back end ${nowtime} =============="