#!/bin/bash

# Obtener las variables iniciales
source ./get-variables.sh
source ./get-variables-delete.sh

# Eliminar el perfil de la instancia
aws iam remove-role-from-instance-profile \
  --instance-profile-name $INSTANCE_PROFILE_NAME \
  --role-name $ROLE_NAME \
  --region $AWS_REGION
echo "El IAM role $ROLE_NAME ha sido removido de la instance profile $INSTANCE_PROFILE_NAME de forma exitosa."

aws iam delete-instance-profile \
  --instance-profile-name $INSTANCE_PROFILE_NAME \
  --region $AWS_REGION
echo "La instance profile $INSTANCE_PROFILE_NAME ha sido eliminado exitosamente."

# Eliminando el IAM Role
aws iam detach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn $POLICY_ARN \
  --region $AWS_REGION
echo "El role policy $POLICY_ARN ha sido deattachado al IAM role $ROLE_NAME de forma exitosa."

aws iam delete-role \
  --role-name $ROLE_NAME \
  --region $AWS_REGION
echo "El IAM Role $ROLE_NAME ha sido eliminado exitosamente."

# Elimando el security group
aws ec2 delete-security-group \
  --group-id $GROUP_ID \
  --region $AWS_REGION
echo "El security group $GROUP_ID ha sido eliminado exitosamente."