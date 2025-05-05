#!/bin/bash

# Verificar si el script tiene permisos de root. Si no, reiniciar con sudo.
if [ "$EUID" -ne 0 ]; then
  echo "El script necesita permisos de administrador. Solicitando permisos..."
  exec sudo "$0" "$@"
fi

# Solicitar confirmación
read -p "¿Estás seguro de que quieres lanzar los contenedores? (S/n): " confirm
if [[ "$confirm" != "S" && "$confirm" != "s" ]]; then
  echo "Ejecución cancelada."
  exit 0
fi

# Crear carpetas solo si no existen
echo "Verificando existencia de carpetas necesarias..."
mkdir -p elasticsearch kibana nifi_registry nifi ./nifi/conf ./nifi/certs certs

# Establecer permisos a los volúmenes
echo "Ajustando permisos para carpetas..."
chmod g+rwx elasticsearch kibana nifi_registry nifi nifi/conf certs
chgrp 0 elasticsearch kibana nifi_registry nifi nifi/conf certs

# # Copiar configuración de NiFi solo si no está presente
# if [ ! -f "./nifi/conf/nifi.properties" ]; then
#   echo "Copiando configuración de NiFi..."
#   cp -r nifi_docker/conf/* nifi/conf/
# else
#   echo "Configuración de NiFi ya está presente. No se copiará de nuevo."
# fi

sudo ./nifi/generate_certs.sh

# Arrancar docker-compose para Elasticsearch, Kibana y NiFi
echo "Iniciando docker-compose para Elasticsearch, Kibana y NiFi..."
docker compose -f docker-compose.yaml up -d

# Esperar hasta que Elasticsearch esté completamente listo
echo "Esperando a que Elasticsearch esté listo..."
until docker compose -f docker-compose.yaml exec -T kibana curl -s http://localhost:5601/api/status | grep -q '"level":"available"'; do
  echo "Esperando que Kibana esté disponible..."
  sleep 5
done
# until curl -s https://localhost:8443/nifi-api/flow/about | grep -q '"version"'; do
#   echo "Esperando que NiFi esté listo..."
#   sleep 5
# done

docker compose -f openmetadata/docker-compose-openmetadata.yaml up -d
docker compose -f postgres/docker-compose-postgres.yaml up -d
docker compose -f ollama/docker-compose-ollama.yaml up -d

echo "Todos los servicios están en marcha."
