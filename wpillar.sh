#!/bin/bash

##  docker compose down -v --rmi all --remove-orphans
##  docker compose exec -w/var/www/projects/wpillar php wp --allow-root db create
##  docker compose exec -w/projects/wpillar composer composer install

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
  project_name=$1;
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
    init)
      docker compose up -d
      docker compose exec composer composer global exec phing
      ;;
    restart)
      docker compose restart
      ;;
    stop)
      docker compose stop
      ;;
    down)
      docker compose down -v --rmi all --remove-orphans
      ;;
        cert)
        case "$2" in
            root)
                cert_root_ca $3
                ;;
            generate)
                cert_generate $3
                ;;
            install)
                cert_install $3
                ;;
            *)
                cat << EOF

Certificate management commands.

Usage:
    wpillar cert <command> <domain_name>

Available commands:
    generate .................................. Generate a new certificate
    install ................................... Install the certificate

EOF
                ;;
        esac
        ;;
    *)
        cat << EOF

Command line interface for the Docker-based web development environment tribe-stairs.

Usage:
    wpillar <command> [options] [arguments]

Available commands:
    cert ...................................... Certificate management commands
         generate ............................. Generate a new certificate
         install .............................. Install the certificate
    init ...................................... Installs or Updates all projects inside the projects.json file. If no
                                                file is found, it creates one.
    update .................................... Installs or Updates all projects inside the projects.json file. If no
                                                file is found, it creates one.
    down [-v] ................................. Stop and destroy all containers
                                                Options:
                                                    -v .................... Destroy the volumes as well
    logs [container] .......................... Display and tail the logs of all containers or the specified one's
    restart ................................... Restart the containers
    start ..................................... Start the containers
    stop ...................................... Stop the containers


EOF
        exit 1
        ;;
esac