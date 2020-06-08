#AWS variables
variable "account_cred" {
  description = "AWS account credentials file"
}

variable "aws_region" {
  description = "Sets region for AWS session"
}

#ec2 variables
variable "ec2_instance_type" {
  description = "Sets the machine type for instance"
}

variable "ec2_ami" {
  description = "ami for the ec2"
}

variable "bastion_key_name" {
  description = "Name of key for log on to bastion from localhost"
}

variable "db_key_name" {
  description = "Name of key for log on to db from bastion host"
}

variable "bastion_public_key" {
  description = "Location of bastion public SSH key"
}

 variable "db_public_key" {
   description = "Location of db public SSH key"
 }

 variable "web_public_key" {
   description = "Location of web server public SSH key"
 }

 variable "web_key_name" {
   description = "Name of key for log on to web server from bastion host"
 }
