#!/bin/bash

# Obtener las variables iniciales
source ../variable-initial.sh
source ./variable-database.sh

#####################################
# Amazon RDS for MySQL
#####################################
# aws rds delete-db-instance \
#   --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
#   --skip-final-snapshot \
#   --region $AWS_REGION > result.log
# echo "La RDS instance ($DB_INSTANCE_IDENTIFIER) se está eliminando..."

# # Esperar hasta que la instancia esté en estado 'deleted'
# aws rds wait db-instance-deleted --db-instance-identifier $DB_INSTANCE_IDENTIFIER
# echo "La RDS instance ($DB_INSTANCE_IDENTIFIER) ha sido eliminada exitosamente."

#####################################
# Amazon Aurora for MySQL
#####################################
aws rds delete-db-instance \
  --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
  --skip-final-snapshot \
  --region $AWS_REGION > result.log
echo "La RDS instance ($DB_INSTANCE_IDENTIFIER) se está eliminando..."

# Esperar hasta que la instancia esté en estado 'deleted'
aws rds wait db-instance-deleted --db-instance-identifier $DB_INSTANCE_IDENTIFIER
echo "La RDS instance ($DB_INSTANCE_IDENTIFIER) ha sido eliminada exitosamente."

aws rds delete-db-cluster \
  --db-cluster-identifier $DB_CLUSTER_IDENTIFIER \
  --skip-final-snapshot \
  --region $AWS_REGION > result.log
echo "La RDS cluster ($DB_CLUSTER_IDENTIFIER) se está eliminando..."

# Esperar hasta que la instancia esté en estado 'deleted'
aws rds wait db-cluster-deleted --db-cluster-identifier $DB_CLUSTER_IDENTIFIER
echo "La RDS cluster ($DB_CLUSTER_IDENTIFIER) ha sido eliminada exitosamente."