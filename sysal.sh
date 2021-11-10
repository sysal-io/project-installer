#!/bin/bash

##  docker compose down -v --rmi all --remove-orphans
##  docker compose exec -w/var/www/projects/wpillar php wp --allow-root db create
##  docker compose exec -w/projects/wpillar composer composer install

case "$1" in
    init)
      docker compose up -d
      docker compose exec composer composer global exec phing
      ;;
    restart)
      docker compose restart
      ;;
    start)
      docker compose start
      ;;
    stop)
      docker compose stop
      ;;
    down)
      docker compose down -v --rmi all --remove-orphans
      ;;
    cert)
      ./.scripts/certificates.sh $2
      ;;
    create)
      ./.scripts/create.sh $2 $3
      ;;
    *)
        cat << EOF

Command line interface for the Docker-based web development environment tribe-stairs.

Usage:
    sysal <command> [options] [arguments]

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