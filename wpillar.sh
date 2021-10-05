#!/bin/bash

parent_dir=$(
	cd "$(dirname "${BASH_SOURCE[0]}")"
	pwd -P
)

phing=".composer/vendor/bin/phing"
wpillar="./wpillar"

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
    stop)
      docker compose stop
      ;;
    down)
      docker compose down -v --rmi all --remove-orphans
      ;;
    *)
        cat << EOF

Command line interface for the Docker-based web development environment tribe-stairs.

Usage:
    wpillar <command> [options] [arguments]

Available commands:
    init ...................................... Installs or Updates all projects inside the .projects file. If no
                                                file is found, it creates one.
    artisan ................................... Run an Artisan command
    build [image] ............................. Build all of the images or the specified one
    composer .................................. Run a Composer command
    destroy ................................... Remove the entire Docker environment
    down [-v] ................................. Stop and destroy all containers
                                                Options:
                                                    -v .................... Destroy the volumes as well
    init ...................................... Initialise the Docker environment and the application
    logs [container] .......................... Display and tail the logs of all containers or the specified one's
    restart ................................... Restart the containers
    start ..................................... Start the containers
    stop ...................................... Stop the containers
    update .................................... Update the Docker environment
    yarn ...................................... Run a Yarn command

EOF
        exit 1
        ;;
esac