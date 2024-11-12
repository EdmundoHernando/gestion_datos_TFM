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

# Copiar configuración de NiFi solo si no está presente
if [ ! -f "./nifi/conf/nifi.properties" ]; then
  echo "Copiando configuración de NiFi..."
  cp -r nifi_docker/conf/* nifi/conf/
else
  echo "Configuración de NiFi ya está presente. No se copiará de nuevo."
fi

# Crear certificados solo si no existen
if [ ! -f "./nifi/certs/nifi-keystore.p12" ]; then
  echo "Generando certificados de NiFi..."
  keytool -genkeypair -alias nifi -keyalg RSA -keysize 2048 \
    -keystore ./nifi/certs/nifi-keystore.p12 -storepass gatvgatv \
    -keypass gatvgatv -dname "CN=NiFi, OU=Dev, O=Org, L=City, S=State, C=Country" \
    -storetype PKCS12
  keytool -exportcert -alias nifi -keystore ./nifi/certs/nifi-keystore.p12 \
    -storepass gatvgatv -file ./nifi/certs/nifi-cert.pem
else
  echo "Certificados de NiFi ya existen. No se generarán de nuevo."
fi

# Arrancar docker-compose para Elasticsearch, Kibana y NiFi
echo "Iniciando docker-compose para Elasticsearch, Kibana y NiFi..."
docker compose -f docker-compose.yaml up -d

# Esperar hasta que Elasticsearch esté completamente listo
echo "Esperando a que Elasticsearch esté listo..."
until docker compose -f docker-compose.yaml exec -T kibana curl -s http://localhost:5601/api/status | grep -q '"level":"available"'; do
  echo "Esperando que Kibana esté disponible..."
  sleep 5
done
until curl -s http://localhost:8091/nifi-api/flow/about | grep -q '"version"'; do
  echo "Esperando que NiFi esté listo..."
  sleep 5
done

echo "Todos los servicios están en marcha."
