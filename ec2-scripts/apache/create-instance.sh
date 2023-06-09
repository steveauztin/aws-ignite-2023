#!/bin/bash

# Obtener las variables iniciales
source ../get-variables.sh
source ./get-variables-instance.sh

# Creando la EC2 instance (Apache)
INSTANCE_ID=$(aws ec2 run-instances \
  --region $AWS_REGION \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --iam-instance-profile Name=$INSTANCE_PROFILE_NAME \
  --security-groups $SECURITY_GROUP_NAME \
  --user-data "$INSTALL_SCRIPT" \
  --block-device-mappings $BLOCK_DEVICE_MAPPINGS \
  --output text \
  --query 'Instances[0].InstanceId')

echo "La EC2 instance Apache ($INSTANCE_ID) se está creando..."
echo "INSTANCE_ID=$INSTANCE_ID" > get-variables-instance-delete.sh

# Esperar hasta que la instancia esté en estado 'running'
aws ec2 wait instance-running --region $AWS_REGION --instance-ids $INSTANCE_ID
echo "La EC2 instance Apache ($INSTANCE_ID) se ha creado exitosamente."

# Esperar hasta que la instancia esté en estado 'ok'
aws ec2 wait instance-status-ok --region $AWS_REGION --instance-ids $INSTANCE_ID

# Solicitamos IP elastica y asociamos a la EC2 Apache
ALLOCATION_ID=$(aws ec2 allocate-address \
  --domain vpc \
  --output text \
  --query 'AllocationId')
echo "ALLOCATION_ID=$ALLOCATION_ID" >> get-variables-instance-delete.sh

ASSOCIATION_ID=$(aws ec2 associate-address \
  --instance-id $INSTANCE_ID \
  --allocation-id $ALLOCATION_ID \
  --output text \
  --query 'AssociationId')
echo "ASSOCIATION_ID=$ASSOCIATION_ID" >> get-variables-instance-delete.sh

# Recuperar la dirección IP pública de la instancia EC2 Apache
PUBLIC_IP=$(aws ec2 describe-instances \
  --region $AWS_REGION \
  --instance-ids $INSTANCE_ID \
  --output text \
  --query 'Reservations[0].Instances[0].PublicIpAddress')
echo "La EC2 instance Apache ($INSTANCE_ID) tiene la dirección IP pública: $PUBLIC_IP"
echo "PUBLIC_IP=$PUBLIC_IP" >> get-variables-instance-delete.sh

# Conectar por HTTP al servicio de Apache
echo "Conectándose por HTTP al servicio de Apache de la instancia de EC2 ($INSTANCE_ID)..."
echo "curl http://$PUBLIC_IP"
curl http://$PUBLIC_IP

# Conectar por HTTPS al servicio de Apache
echo "Conectándose por HTTP al servicio de Apache de la instancia de EC2 ($INSTANCE_ID)..."
echo "curl -k https://$PUBLIC_IP"
curl -k https://$PUBLIC_IP