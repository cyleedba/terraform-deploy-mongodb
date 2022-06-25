provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
#1. create vpc
resource "aws_vpc" "first_vpc" {
  cidr_block       = var.aws_vpc_cidr
  tags = {
    Name = "demo_vpc"
  }
}
#2. create internet gateway

resource "aws_internet_gateway" "demo_gw" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "demo_gw"
  }
}
#3. create custom route table

resource "aws_route_table" "demo_route" {
  vpc_id = aws_vpc.first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.demo_gw.id
  }

  tags = {
    Name = "Demo"
  }
}

#4. create a subnet
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.first_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1b"

    tags = {
      Name = "demo-subnet1"
    }
  
}

#5. associate subnet with route table

resource "aws_route_table_association" "demo_rule" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.demo_route.id
}

#6. create security group to allow 22,27017,443
resource "aws_security_group" "allow_port" {
  name        = "allow_port_rule"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "mongodb protocol"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_port"
  }
}

#7. create redhat server and install/enabled apache2 
resource "aws_instance" "demo-linux-instance" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "us-west-1b"
    key_name = var.key_name
    count = 3   # Here we are creating identical 2 machines. 
    associate_public_ip_address = true
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.allow_port.id]

    user_data = <<-EOF
                #!/bin/bash
                sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo<<EOL
                [mongodb-org-5.0]
                name=MongoDB Repository
                baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
                gpgcheck=1
                enabled=1
                gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
                EOL
                
                sudo yum -y install mongodb-org
                sudo yum -y install mongodb-org-5.0.2 mongodb-org-database-5.0.2 mongodb-org-server-5.0.2 mongodb-org-shell-5.0.2 mongodb-org-mongos-5.0.2 mongodb-org-tools-5.0.2
                cd /
                sudo mkdir /mongodb
                cd /mongodb
                sudo mkdir data
                cd /mongodb/data
                sudo mkdir db
                sudo mkdir log 
                sudo mkdir backup              
                sudo tee /mongodb/data/mongodb.conf <<EOL
                dbpath=/mongodb/data/db #資料檔案存放目錄  
                logpath=/mongodb/data/log/mongodb.log #日誌檔案存放目錄  
                port=27017
                fork=true  #以守護程式的方式啟用，即在後臺執行  
                bind_ip=0.0.0.0
                auth=true
                keyFile=/mongodb/data/.keyfile
                EOL

                sudo tee /home/ec2user/create_user.js <<EOL
                use admin
                db.createUser(
                {
                    user: "root",
                    pwd: "qwe123",
                    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase","clusterAdmin" ]
                }
                )
                EOL
                EOF
    tags = {
      Name = "mongodb-${count.index}"
           }
}

output "server_private_ip" {
    value = aws_instance.demo-linux-instance.*.private_ip
}

output "server_id" {
    value = aws_instance.demo-linux-instance.*.id
}

output "server_public" {
    value = aws_instance.demo-linux-instance.*.public_ip
  
}