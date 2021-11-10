#!/bin/bash

# Generate root Certificate
function cert_root_ca() {
    docker compose exec nginx openssl genrsa -des3 -out /etc/nginx/certs/rootCA.key 2048
    docker compose exec nginx openssl req -x509 -new -nodes -key /etc/nginx/certs/rootCA.key -sha256 -days 1460 -out /etc/nginx/certs/rootCA.pem
}

function cert_generate() {
    docker compose exec nginx openssl req -new -sha256 -nodes -out /etc/nginx/certs/server.csr -newkey rsa:2048 -keyout /etc/nginx/certs/server.key -config /etc/nginx/certs/server.csr.cnf
    docker compose exec nginx openssl x509 -req -in /etc/nginx/certs/server.csr -CA /etc/nginx/certs/rootCA.pem -CAkey /etc/nginx/certs/rootCA.key -CAcreateserial -out /etc/nginx/certs/server.crt -days 500 -sha256 -extfile /etc/nginx/certs/v3.ext
}

# Install the certificate
function cert_install () {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ".docker/nginx/certs/server.crt"
  elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo ln -s "$(pwd)/.docker/nginx/certs/server.crt" "/usr/local/share/ca-certificates/server.crt"
    sudo update-ca-certificates
  else
    echo "Could not install the certificate on the host machine, please do it manually"
  fi
}

case "$1" in
  root)
    cert_root_ca
    ;;
  generate)
    cert_generate
    ;;
  install)
    cert_install
    ;;
  *)
    cat << EOF

Certificate management commands.

Usage:
    sysal cert <command>

Available commands:
    generate .................................. Generate a new certificate
    install ................................... Install the certificate

EOF
    ;;
esac