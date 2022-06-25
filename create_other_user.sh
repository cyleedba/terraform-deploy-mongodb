#!/bin/bash

# Database credentials
user="root"
password="qwe123"
port=27017
#timestamp=$(date)
server=$(hostname)

mongo $server:$port/admin -u $user -p $password < create_other_user.js