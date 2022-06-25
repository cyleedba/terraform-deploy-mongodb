variable "access_key" {
  type = string
  default = "AKIAQK5AZRHNEPBQFTS4" 
}

variable "secret_key" {
  type = string
  default = "oocNFt9oAtc2mYAVe9J7wsC4pjTcZnCk3swv9lFW"
}

variable "region" {
  type = string
  default = "us-west-1"
}

variable "instance_type" {
  type = string
  default = "t2.micro"  
}

variable "ami" {
  type = string
  default = "ami-0186e3fec9b0283ee"
}

variable "key_name" {
  type = string
  default = "access-key"
}

variable "availability_zone" {
  type = string
  default = "us-west-1b" 
}

variable "aws_vpc_cidr" {
  default = "10.0.0.0/16"
}