#!/bin/bash

# Verificar si el script tiene permisos de root. Si no, reiniciar con sudo.
if [ "$EUID" -ne 0 ]; then
  echo "El script necesita permisos de administrador. Solicitando permisos..."
  exec sudo "$0" "$@"
fi

# Solicitar confirmación
read -p "Este proceso borrará toda la información almacenada en los contenedores ¿Seguro que quieres continuar? (S/n): " confirm
if [[ "$confirm" != "S" && "$confirm" != "s" ]]; then
  echo "Ejecución cancelada."
  exit 0
fi

docker compose -f docker-compose.yaml down

sudo rm -rf elasticsearch
sudo rm -rf kibana
sudo rm -rf nifi_registry
# sudo rm -rf nifi
# sudo rm -rf ./nifi/conf
sudo rm -rf certs
sudo rm -rf ./nifi/certs
