use admin

db.createUser(
{
user: "root",
pwd: "qwe123",
roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase","clusterAdmin" ]
}
)

db.auth("root","qwe123")

