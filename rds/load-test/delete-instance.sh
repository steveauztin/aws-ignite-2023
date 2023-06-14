#!/bin/bash

# Obtener las variables iniciales
source ../variable-initial.sh
source ./variable-instance-delete.sh

# Eliminando la EC2 instance
aws ec2 terminate-instances \
  --instance-ids $EC2_ID \
  --region $AWS_REGION > result.log
echo "La EC2 instance ($EC2_ID) se está eliminando..."

# Esperar hasta que la instancia esté en estado 'terminated'
aws ec2 wait instance-terminated --instance-ids $EC2_ID
echo "La EC2 instance ($EC2_ID) ha sido eliminada exitosamente."