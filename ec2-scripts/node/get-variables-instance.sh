#!/bin/bash

# Variable de user data para Node
INSTALL_SCRIPT="#!/bin/bash
                 yum update -y
                 curl -sL https://rpm.nodesource.com/setup_14.x | bash -
                 yum install -y nodejs
                 echo '#############################################'
                 echo 'Step 1: Instalar OpenSSL'
                 echo '#############################################'
                 yum install -y mod_ssl openssl
                 echo '#############################################'
                 echo 'Step 2: Generar llave privada'
                 echo '#############################################'
                 openssl req -nodes -x509 -newkey rsa:4096 -keyout node.key -out node-certificate.crt -days 7300 -subj '/CN=bootcamp.com' -addext 'keyUsage = digitalSignature, keyEncipherment, dataEncipherment, cRLSign, keyCertSign' -addext 'extendedKeyUsage = serverAuth' -addext 'subjectAltName = DNS:*.bootcamp.com,DNS:bootcamp.com'
                 echo '#############################################'
                 echo 'Step 3: Guardar las llaves generadas en el directorio especifico de certificados'
                 echo '#############################################'
                 mv node-certificate.crt /etc/pki/tls/certs/localhost.crt
                 mv node.key /etc/pki/tls/private/localhost.key
                 echo '#############################################'
                 echo 'Step 4: Creamos el servidor'
                 echo '#############################################'
                 echo 'const https = require(\"node:https\");' > /home/ec2-user/index.js
                 echo 'const fs = require(\"node:fs\");' >> /home/ec2-user/index.js
                 echo '' >> /home/ec2-user/index.js
                 echo 'const options = {' >> /home/ec2-user/index.js
                 echo '  key: fs.readFileSync(\"/etc/pki/tls/private/localhost.key\"),' >> /home/ec2-user/index.js
                 echo '  cert: fs.readFileSync(\"/etc/pki/tls/certs/localhost.crt\"),' >> /home/ec2-user/index.js
                 echo '};' >> /home/ec2-user/index.js
                 echo '' >> /home/ec2-user/index.js
                 echo 'https.createServer(options, (req, res) => {' >> /home/ec2-user/index.js
                 echo '  res.writeHead(200);' >> /home/ec2-user/index.js
                 echo '  res.end(\"<h1>Bootcamp AWS Ignite 2023 Node!</h1><h3>Hello, I am Steven Fernandez</h3>\");' >> /home/ec2-user/index.js
                 echo '}).listen(443);' >> /home/ec2-user/index.js
                 echo '#############################################'
                 echo 'Step 5: Iniciamos el servidor'
                 echo '#############################################'
                 node /home/ec2-user/index.js"