#!/bin/bash

# Obtener las variables iniciales
source ../variable-initial.sh
source ../variable-delete.sh

#####################################
# Amazon RDS for MySQL
######################################
# DB_INSTANCE_IDENTIFIER="bootcamp-db"
# DB_INSTANCE_CLASS="db.t3.micro"
# SECURITY_GROUP_IDS=$RDS_GROUP_ID
# ENGINE="mysql"
# ENGINE_VERSION="8.0.28"
# MASTER_USERNAME="bootcamp"
# MASTER_USER_PASSWORD=""
# ALLOCATED_STORAGE=20
# BACKUP_RETENTION_PERIOD=0

#####################################
# Amazon Aurora for MySQL
#####################################
DB_CLUSTER_IDENTIFIER="bootcamp-cluster-db"
ENGINE="aurora-mysql"
ENGINE_VERSION="8.0.mysql_aurora.3.02.0"
MASTER_USERNAME="bootcamp"
MASTER_USER_PASSWORD=""
SERVERLESS_V2_SCALING_CONFIGURATION="MinCapacity=1,MaxCapacity=8"
BACKUP_RETENTION_PERIOD=1
SECURITY_GROUP_IDS=$RDS_GROUP_ID

DB_INSTANCE_IDENTIFIER="bootcamp-db"
DB_INSTANCE_CLASS="db.serverless"
