#!/bin/bash

docker exec -it nifi_container_persistent bash
# Crear directorio para los certificados si no existe
mkdir -p /opt/nifi/nifi-current/certs

# Generar el truststore
keytool -genkeypair -alias nifi -keyalg RSA -keysize 2048 -keystore /opt/nifi/nifi-current/certs/nifi-keystore.p12 -storepass gatvgatv -keypass gatvgatv -dname "CN=NiFi, OU=Dev, O=Org, L=City, S=State, C=Country" -storetype PKCS12

# Exportar el truststore
keytool -exportcert -alias nifi -keystore /opt/nifi/nifi-current/certs/nifi-keystore.p12 -storepass gatvgatv -file /opt/nifi/nifi-current/certs/nifi-cert.pem

# Generar el truststore para el cliente
keytool -genkeypair -alias client -keyalg RSA -keysize 2048 -keystore /opt/nifi/nifi-current/certs/nifi-client-keystore.p12 -storepass gatvgatv -keypass gatvgatv -dname "CN=Client, OU=Dev, O=Org, L=City, S=State, C=Country" -storetype PKCS12

# Exportar el truststore del cliente
keytool -exportcert -alias client -keystore /opt/nifi/nifi-current/certs/nifi-client-keystore.p12 -storepass gatvgatv -file /opt/nifi/nifi-current/certs/nifi-client-cert.pem
