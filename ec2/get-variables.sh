#!/bin/bash

AWS_REGION="us-east-1"
#Variables para obtener Ip actual
MY_IP=$(curl -s http://checkip.amazonaws.com)

# Variables Security Group
GROUP_NAME="bootcamp-security-group"
DESCRIPTION="Bootcamp security group"
VPC_ID="vpc-0886bc15cc48e167b"
#Variables Puertos
PORT_HTTP=80
PORT_HTTPS=443

# Variables IAM Role
ROLE_NAME="bootcamp-instance-role"
ASSUME_ROLE_POLICY_DOCUMENT="file://./trusted-entities-policy.json"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
INSTANCE_PROFILE_NAME="bootcamp-instance-profile"

# Variables para EC2 - Amazon linux
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_NAME=$GROUP_NAME
AMI_ID="ami-0715c1897453cabd1"
BLOCK_DEVICE_MAPPINGS="file://../block-device-mappings.json"