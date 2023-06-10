#!/bin/bash

# Variable de user data para Apache
INSTALL_SCRIPT="#!/bin/bash
                 yum update -y
                 yum install -y httpd
                 echo '<h1>Bootcamp AWS Ignite 2023 Apache!</h1><h3>Hello, I am Steven Fernandez</h3>' > /var/www/html/index.html
                 systemctl start httpd
                 systemctl enable httpd
                 echo '#############################################'
                 echo 'Step 1: Instalar OpenSSL'
                 echo '#############################################'
                 yum install -y mod_ssl openssl
                 echo '#############################################'
                 echo 'Step 2: Generar llave privada'
                 echo '#############################################'
                 openssl req -nodes -x509 -newkey rsa:4096 -keyout apache.key -out apache-certificate.crt -days 7300 -subj '/CN=bootcamp.com' -addext 'keyUsage = digitalSignature, keyEncipherment, dataEncipherment, cRLSign, keyCertSign' -addext 'extendedKeyUsage = serverAuth' -addext 'subjectAltName = DNS:*.bootcamp.com,DNS:bootcamp.com'
                 echo '#############################################'
                 echo 'Step 3: Guardar las llaves generadas en el directorio especifico de certificados'
                 echo '#############################################'
                 mv apache-certificate.crt /etc/pki/tls/certs/localhost.crt
                 mv apache.key /etc/pki/tls/private/localhost.key
                 echo '#############################################'
                 echo 'Step 4: Reiniciar Apache'
                 echo '#############################################'
                 systemctl restart httpd"