#!/bin/bash

# Obtener las variables iniciales
source ../get-variables.sh
source ./get-variables-instance-delete.sh

# Eliminando la EC2 instance (Python)
aws ec2 terminate-instances \
  --instance-ids $INSTANCE_ID \
  --region $AWS_REGION
echo "La EC2 instance Python ($INSTANCE_ID) se está eliminando..."

# Esperar hasta que la instancia esté en estado 'terminated'
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
echo "La EC2 instance Python ($INSTANCE_ID) ha sido eliminada exitosamente."