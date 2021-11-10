#!/bin/bash

case "$1" in
  new)
    case "$2" in
      project)
        docker compose exec composer composer global exec phing
      ;;
      *)
        ./sysal.sh create
      ;;
    esac
    ;;
  database)
    cert_generate
    ;;
  install)
    cert_install
    ;;
  *)
    cat << EOF

Create commands.

Usage:
    sysal create <command>

Available commands:
    new project .................................. Create a project using the sysal.io template
    install ................................... Install the certificate

EOF
    ;;
esac