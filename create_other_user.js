db.createUser(
{
user: "dbackup",
pwd: "qwe123",
roles: [ { role: "backup", db: "admin" } ]
}
)

db.createUser(
   {
     user: "monitor",
     pwd: "qwe123",
     roles: [ "clusterMonitor" ]
   }
 )

db.auth("dbackup","qwe123")
db.auth("monitor","qwe123")