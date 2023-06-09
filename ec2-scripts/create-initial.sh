#!/bin/bash

# Obtener las variables iniciales
source ./get-variables.sh

if aws ec2 describe-security-groups --group-names "$GROUP_NAME" >/dev/null 2>&1; then
  echo "El grupo de seguridad $GROUP_NAME ya existe. No es necesario crearlo."
else
  # Creando el security group
  GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$GROUP_NAME" \
    --description "$DESCRIPTION" \
    --vpc-id "$VPC_ID" \
    --output text \
    --query 'GroupId')
  echo "El security group $GROUP_ID ($GROUP_NAME) ha sido creado exitosamente."
  echo "GROUP_ID=$GROUP_ID" > get-variables-delete.sh
fi

GROUP_DESCRIPTION=$(aws ec2 describe-security-groups --group-names "$GROUP_NAME")

if echo "$GROUP_DESCRIPTION" | grep -q "\"FromPort\": $PORT_HTTP,"; then
  echo "El puerto $PORT_HTTP está configurado en el security group $GROUP_NAME."
else
  # Habilitando el acceso HTTP (puerto 80)
  aws ec2 authorize-security-group-ingress \
    --group-id "$GROUP_ID" \
    --protocol tcp \
    --port $PORT_HTTP \
    --cidr $MY_IP/32
  echo "Se ha habilitado el acceso HTTP (puerto 80) en el security group $GROUP_ID ($GROUP_NAME)."
fi

if echo "$GROUP_DESCRIPTION" | grep -q "\"FromPort\": $PORT_HTTPS,"; then
  echo "El puerto $PORT_HTTPS está configurado en el security group $GROUP_NAME."
else
  # Habilitando el acceso HTTPS (puerto 443)
  aws ec2 authorize-security-group-ingress \
    --group-id "$GROUP_ID" \
    --protocol tcp \
    --port $PORT_HTTPS \
    --cidr $MY_IP/32
  echo "Se ha habilitado el acceso HTTPS (puerto 443) en el security group $GROUP_ID ($GROUP_NAME)."
fi

if aws iam get-role --role-name $ROLE_NAME --region $AWS_REGION >/dev/null 2>&1; then
  echo "El IAM role $ROLE_NAME ya existe. No es necesario crearlo."
else
  # Creando el IAM Role
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document $ASSUME_ROLE_POLICY_DOCUMENT \
    --region $AWS_REGION
  echo "El IAM role $ROLE_NAME ha sido creado exitosamente."
#   echo "ROLE_NAME=$ROLE_NAME" >> get-variables-delete.sh

  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn $POLICY_ARN \
    --region $AWS_REGION
  echo "El role policy $POLICY_ARN ha sido attachado al IAM role $ROLE_NAME de forma exitosa."
#   echo "POLICY_ARN=$POLICY_ARN" >> get-variables-delete.sh
fi

if aws iam get-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME --region $AWS_REGION >/dev/null 2>&1; then
  echo "El instance profile $INSTANCE_PROFILE_NAME ya existe. No es necesario crearlo."
else
  # Creando el instance profile
  aws iam create-instance-profile \
    --instance-profile-name $INSTANCE_PROFILE_NAME \
    --region $AWS_REGION
  echo "El instance profile $INSTANCE_PROFILE_NAME ha sido creaada exitosamente."
#   echo "INSTANCE_PROFILE_NAME=$INSTANCE_PROFILE_NAME" >> get-variables-delete.sh

  aws iam add-role-to-instance-profile \
    --instance-profile-name $INSTANCE_PROFILE_NAME \
    --role-name $ROLE_NAME \
    --region $AWS_REGION
  echo "El IAM role $ROLE_NAME ha sido agregado a la instance profile $INSTANCE_PROFILE_NAME de forma exitosa."
fi