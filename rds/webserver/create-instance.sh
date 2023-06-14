#!/bin/bash

# Obtener las variables iniciales
source ./variable-instance.sh

# Creando la EC2 instance
EC2_ID=$(aws ec2 run-instances \
  --region $AWS_REGION \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --tag-specifications "ResourceType=instance,Tags=[$TAG_SPECIFICATIONS]" \
  --iam-instance-profile Name=$INSTANCE_PROFILE_NAME \
  --security-groups $SECURITY_GROUP_NAME \
  --user-data $USER_DATA \
  --block-device-mappings $BLOCK_DEVICE_MAPPINGS \
  --output text \
  --query 'Instances[0].InstanceId')
echo "La EC2 instance ($EC2_ID) se está creando..."
echo "EC2_ID=$EC2_ID" > variable-instance-delete.sh

# Esperar hasta que la instancia esté en estado 'running'
aws ec2 wait instance-running --region $AWS_REGION --instance-ids $EC2_ID
echo "La EC2 instance ($EC2_ID) se ha creado exitosamente."

# Esperar hasta que la instancia esté en estado 'ok'
aws ec2 wait instance-status-ok --region $AWS_REGION --instance-ids $EC2_ID

# Recuperar la dirección IP pública de la instancia
PUBLIC_IP=$(aws ec2 describe-instances \
  --region $AWS_REGION \
  --instance-ids $EC2_ID \
  --output text \
  --query 'Reservations[0].Instances[0].PublicIpAddress')
echo "La EC2 instance ($EC2_ID) tiene la dirección IP pública: $PUBLIC_IP"