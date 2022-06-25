#plan 使用 terraform 腳本 來deploy 3台 aws instance ( source :redhat8 , instance_type = t2.micro ) , 創建後在配置mongodb replica 的相關參數與 備份.還原.監控腳本


#terraform 用的腳本 main.tf 跟 variables.tf 
#3台instance 在同個subnet 下 private ip隨機分配  
#在拿ssh key 登入到各台主機 把各台的hostname ip 都加進去 /etc/hosts
#配置 mongodb 相關設置 從mongo[0] 第一台創建 openssl 後再cp 到其他兩台上 相關指令如下
#openssl rand -base64 756 > .keyfile
#sudo chown -R root:root .keyfile
#sudo chmod 400 .keyfile
#sudo mv .keyfile /mongodb/data/  
#sudo scp -i "/home/ec2-user/access-key.pem" .keyfile other db

#mongo < create_admin_user.js
#root 帳號創建後在創建其他users 使用到的腳本是create_other_user.sh
#sh create_other_user.sh 
#create_other_user.sh 是執行創建mongodb其他帳號的script  create_other_user.js monoshell 創建帳號的script
#重新啟動mongodb replica 
#--master 
#sudo mongod -f /mongodb/data/mongodb.conf --replSet replicaSet1

#--slave 1 
#sudo mongod -f /mongodb/data/mongodb.conf --replSet replicaSet1

#--slave 2
#sudo mongod -f /mongodb/data/mongodb.conf --replSet replicaSet1

#在master 節點執行
#rs.initiate()
#rs.add("slave1-host:27017")
#rs.add("slave2-host:27017")

#--查看同步狀態 確認都有連上
#rs.status()

#replication_lag.sh 監控mongodb replica 同步延遲腳本

#backup.sh 備份mongodb 腳本

#mongoStats.sh 監控mongo stats 腳本

#restore.sh 還原資料腳本
