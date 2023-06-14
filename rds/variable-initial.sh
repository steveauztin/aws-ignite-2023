#!/bin/bash

# Variables globales
AWS_REGION="us-east-1"
MY_IP=$(curl -s http://checkip.amazonaws.com)
VPC_ID="vpc-0886bc15cc48e167b"

# Variables Security Group
EC2_GROUP_NAME="ec2-bootcamp-sg"
EC2_GROUP_DESCRIPTION="Bootcamp security group"

# Variables Security Group
RDS_GROUP_NAME="rds-bootcamp-sg"
RDS_GROUP_DESCRIPTION="DB Bootcamp security group"

#Variables Puertos
PORT_HTTP=80
PORT_HTTPS=443
PORT_MYSQL=3306

# Variables IAM Role
EC2_ROLE_NAME="ec2-bootcamp-role"
EC2_PROFILE_NAME="ec2-bootcamp-profile"
ASSUME_ROLE_POLICY_DOCUMENT="file://./trusted-entities-policy.json"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"