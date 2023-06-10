#!/bin/bash

# Variable de user data para Python
INSTALL_SCRIPT="#!/bin/bash
                 yum update -y
                 yum install -y python3
                 yum install -y python3-pip
                 pip3 install Flask
                 echo '#############################################'
                 echo 'Step 1: Instalar OpenSSL'
                 echo '#############################################'
                 yum install -y mod_ssl openssl
                 echo '#############################################'
                 echo 'Step 2: Generar llave privada'
                 echo '#############################################'
                 openssl req -nodes -x509 -newkey rsa:4096 -keyout python.key -out python-certificate.crt -days 7300 -subj '/CN=bootcamp.com' -addext 'keyUsage = digitalSignature, keyEncipherment, dataEncipherment, cRLSign, keyCertSign' -addext 'extendedKeyUsage = serverAuth' -addext 'subjectAltName = DNS:*.bootcamp.com,DNS:bootcamp.com'
                 echo '#############################################'
                 echo 'Step 3: Guardar las llaves generadas en el directorio especifico de certificados'
                 echo '#############################################'
                 mv python-certificate.crt /home/ec2-user
                 mv python.key /home/ec2-user
                 echo '#############################################'
                 echo 'Step 5: Creamos el archivo inicial'
                 echo '#############################################'
                 echo 'from flask import Flask' > /home/ec2-user/hello.py
                 echo 'app = Flask(__name__)' >> /home/ec2-user/hello.py
                 echo '' >> /home/ec2-user/hello.py
                 echo '@app.route(\"/\")' >> /home/ec2-user/hello.py
                 echo 'def hello():' >> /home/ec2-user/hello.py
                 echo '    return \"<h1>Bootcamp AWS Ignite 2023 Python!</h1><h3>Hello, I am Steven Fernandez</h3>\"' >> /home/ec2-user/hello.py
                 echo '' >> /home/ec2-user/hello.py
                 echo 'if __name__ == \"__main__\":' >> /home/ec2-user/hello.py
                 echo '    app.run()' >> /home/ec2-user/hello.py
                 echo '#############################################'
                 echo 'Step 5: Iniciamos el servidor'
                 echo '#############################################'
                 cd /home/ec2-user
                 flask --app hello run --host=0.0.0.0 --port 443 --cert=python-certificate.crt --key=python.key"