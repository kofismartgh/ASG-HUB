terraform {
  backend "s3" {
    #    bucket = "myterraform-state01" #enable versioning on bucket
    bucket = "myterraform-state01" #enable versioning on bucket
    region = "us-east-1"
    #    dynamodb_table = "myterraformstate-locking" #the hashkey has to be LockID
    key = "mysgtest2.tfstate" #directory

  }
}

provider "aws" {
  region = "us-east-1"
}


import {
  to = aws_security_group.cybersourceSG2
  id = "sg-0f3bbadc059e1ebce"
}

resource "aws_security_group" "cybersourceSG2" {
        description            = "launch-wizard-8 created 2024-07-18T22:07:26.030Z"
        egress                 = [
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 0
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "-1"
                security_groups  = []
                self             = false
                to_port          = 0
            },
        ]
        ingress                = [
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 22
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 22
            },
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 80
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 80
            },
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = "redis"
                from_port        = 6379
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 6380
            },
        ]
        name                   = "EC2-sg"
        revoke_rules_on_delete = false
        region                 = "us-east-1"
        tags                   = {}
        vpc_id                 = "vpc-07539f61"
    }
