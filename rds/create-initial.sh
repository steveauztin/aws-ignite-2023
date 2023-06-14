#!/bin/bash

# Obtener las variables iniciales
source ./variable-initial.sh

# Creación del security group del EC2
if aws ec2 describe-security-groups --group-names "$EC2_GROUP_NAME" >/dev/null 2>&1; then
  echo "El grupo de seguridad $EC2_GROUP_NAME ya existe. No es necesario crearlo."
else
  # Creando el security group
  EC2_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$EC2_GROUP_NAME" \
    --description "$EC2_GROUP_DESCRIPTION" \
    --vpc-id "$VPC_ID" \
    --output text \
    --query 'GroupId')
  echo "El security group $GROUP_ID ($EC2_GROUP_NAME) ha sido creado exitosamente."
  echo "EC2_GROUP_ID=$EC2_GROUP_ID" > variable-delete.sh
fi

GROUP_DESCRIPTION=$(aws ec2 describe-security-groups --group-names "$EC2_GROUP_NAME")

if echo "$GROUP_DESCRIPTION" | grep -q "\"FromPort\": $PORT_HTTP,"; then
  echo "El puerto $PORT_HTTP está configurado para CIDR $MY_IP en el security group $EC2_GROUP_NAME."
else
  # Habilitando el acceso HTTP (puerto 80)
  aws ec2 authorize-security-group-ingress \
    --group-id "$EC2_GROUP_ID" \
    --protocol tcp \
    --port $PORT_HTTP \
    --cidr $MY_IP/32 > result.log
  echo "Se ha habilitado el acceso HTTP (puerto $PORT_HTTP) para CIDR $MY_IP en el security group $EC2_GROUP_ID ($EC2_GROUP_NAME)."
fi

if echo "$GROUP_DESCRIPTION" | grep -q "\"FromPort\": $PORT_HTTPS,"; then
  echo "El puerto $PORT_HTTPS está configurado para CIDR $MY_IP en el security group $EC2_GROUP_NAME."
else
  # Habilitando el acceso HTTPS (puerto 443)
  aws ec2 authorize-security-group-ingress \
    --group-id "$EC2_GROUP_ID" \
    --protocol tcp \
    --port $PORT_HTTPS \
    --cidr $MY_IP/32 >> result.log
  echo "Se ha habilitado el acceso HTTPS (puerto $PORT_HTTPS) para CIDR $MY_IP en el security group $EC2_GROUP_ID ($EC2_GROUP_NAME)."
fi

# Creación del security group del RDS
if aws ec2 describe-security-groups --group-names "$RDS_GROUP_NAME" >/dev/null 2>&1; then
  echo "El grupo de seguridad $RDS_GROUP_NAME ya existe. No es necesario crearlo."
else
  # Creando el security group
  RDS_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$RDS_GROUP_NAME" \
    --description "$RDS_GROUP_DESCRIPTION" \
    --vpc-id "$VPC_ID" \
    --output text \
    --query 'GroupId')
  echo "El security group $RDS_GROUP_ID ($RDS_GROUP_NAME) ha sido creado exitosamente."
  echo "RDS_GROUP_ID=$RDS_GROUP_ID" >> variable-delete.sh
fi

GROUP_DESCRIPTION=$(aws ec2 describe-security-groups --group-names "$RDS_GROUP_NAME")

if echo "$GROUP_DESCRIPTION" | grep -q "\"FromPort\": $PORT_MYSQL,"; then
  echo "El puerto $PORT_MYSQL está configurado para CIDR $MY_IP en el security group $RDS_GROUP_NAME."
else
  # Habilitando el acceso MYSQL (puerto 3306)
  aws ec2 authorize-security-group-ingress \
    --group-id "$RDS_GROUP_ID" \
    --protocol tcp \
    --port $PORT_MYSQL \
    --cidr $MY_IP/32 \
    --source-group $EC2_GROUP_ID >> result.log
  echo "Se ha habilitado el acceso MYSQL (puerto $PORT_MYSQL) para CIDR $MY_IP / SG $EC2_GROUP_ID en el security group $RDS_GROUP_ID ($RDS_GROUP_NAME)."
fi

if aws iam get-role --role-name $EC2_ROLE_NAME --region $AWS_REGION >/dev/null 2>&1; then
  echo "El IAM role $EC2_ROLE_NAME ya existe. No es necesario crearlo."
else
  # Creando el IAM Role
  aws iam create-role \
    --role-name $EC2_ROLE_NAME \
    --assume-role-policy-document $ASSUME_ROLE_POLICY_DOCUMENT \
    --region $AWS_REGION >> result.log
  echo "El IAM role $EC2_ROLE_NAME ha sido creado exitosamente."

  aws iam attach-role-policy \
    --role-name $EC2_ROLE_NAME \
    --policy-arn $POLICY_ARN \
    --region $AWS_REGION >> result.log
  echo "El role policy $POLICY_ARN ha sido attachado al IAM role $EC2_ROLE_NAME de forma exitosa."
fi

if aws iam get-instance-profile --instance-profile-name $EC2_PROFILE_NAME --region $AWS_REGION >/dev/null 2>&1; then
  echo "El instance profile $EC2_PROFILE_NAME ya existe. No es necesario crearlo."
else
  # Creando el instance profile
  aws iam create-instance-profile \
    --instance-profile-name $EC2_PROFILE_NAME \
    --region $AWS_REGION >> result.log
  echo "El instance profile $EC2_PROFILE_NAME ha sido creaada exitosamente."

  aws iam add-role-to-instance-profile \
    --instance-profile-name $EC2_PROFILE_NAME \
    --role-name $EC2_ROLE_NAME \
    --region $AWS_REGION >> result.log
  echo "El IAM role $EC2_ROLE_NAME ha sido agregado a la instance profile $EC2_PROFILE_NAME de forma exitosa."
fi