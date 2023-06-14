#!/bin/bash

# Obtener las variables iniciales
source ./variable-initial.sh
source ./variable-delete.sh

# Eliminar el perfil de la instancia
aws iam remove-role-from-instance-profile \
  --instance-profile-name $EC2_PROFILE_NAME \
  --role-name $EC2_ROLE_NAME \
  --region $AWS_REGION > result.log
echo "El IAM role $EC2_ROLE_NAME ha sido removido de la instance profile $EC2_PROFILE_NAME de forma exitosa."

aws iam delete-instance-profile \
  --instance-profile-name $EC2_PROFILE_NAME \
  --region $AWS_REGION >> result.log
echo "La instance profile $EC2_PROFILE_NAME ha sido eliminado exitosamente."

# Eliminando el IAM Role
aws iam detach-role-policy \
  --role-name $EC2_ROLE_NAME \
  --policy-arn $POLICY_ARN \
  --region $AWS_REGION >> result.log
echo "El role policy $POLICY_ARN ha sido deattachado al IAM role $EC2_ROLE_NAME de forma exitosa."

aws iam delete-role \
  --role-name $EC2_ROLE_NAME \
  --region $AWS_REGION >> result.log
echo "El IAM Role $EC2_ROLE_NAME ha sido eliminado exitosamente."

# Elimando el security group
aws ec2 delete-security-group \
  --group-id $RDS_GROUP_ID \
  --region $AWS_REGION >> result.log
echo "El security group $RDS_GROUP_ID ($RDS_GROUP_NAME) ha sido eliminado exitosamente."

aws ec2 delete-security-group \
  --group-id $EC2_GROUP_ID \
  --region $AWS_REGION >> result.log
echo "El security group $EC2_GROUP_ID ($EC2_GROUP_NAME) ha sido eliminado exitosamente."