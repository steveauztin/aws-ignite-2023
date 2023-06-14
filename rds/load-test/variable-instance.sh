#!/bin/bash

# Obtener las variables iniciales
source ../variable-initial.sh

# Variables para EC2 - Amazon linux
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_NAME=$EC2_GROUP_NAME
INSTANCE_PROFILE_NAME=$EC2_PROFILE_NAME
TAG_SPECIFICATIONS="{Key=Name,Value=bootcamp-load-test}"
AMI_ID="ami-09988af04120b3591"
# AMI_ID="ami-04a0ae173da5807d3"
BLOCK_DEVICE_MAPPINGS="file://block-device-mappings.json"
USER_DATA="file://user-data.sh"