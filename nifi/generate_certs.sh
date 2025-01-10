#!/bin/bash


# Crear certificados solo si no existen
if [ ! -f "./nifi/conf/keystore.p12" ]; then
  echo "Generando certificados de NiFi..."
  keytool -genkeypair -alias nifi -keyalg RSA -keysize 2048 \
    -keystore ./nifi/conf/keystore.p12 -storepass gatvgatv \
    -keypass gatvgatv -dname "CN=NiFi, OU=Dev, O=Org, L=City, S=State, C=Country" \
    -storetype PKCS12
  keytool -exportcert -alias nifi -keystore ./nifi/conf/keystore.p12 \
    -storepass gatvgatv -file ./nifi/conf/nifi-cert.pem
else
  echo "Certificados de NiFi ya existen. No se generarán de nuevo."
fi


if [ ! -f "./nifi/conf/truststore.p12" ]; then
  echo "Generando TrustStore de NiFi (PKCS12)..."
  keytool -import -alias nifi-cert \
    -file ./nifi/conf/nifi-cert.pem \
    -keystore ./nifi/conf/truststore.p12 \
    -storepass gatvgatv -storetype PKCS12 -noprompt
else
  echo "El TrustStore de NiFi (PKCS12) ya existe. No se generará de nuevo."
fi