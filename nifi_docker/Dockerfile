# Usa la imagen base de NiFi
FROM apache/nifi:1.14.0

# Cambiar al usuario root para permitir cambios de permisos
USER root

# Crear directorio para los certificados si no existe
RUN mkdir -p /opt/nifi/nifi-current/certs
RUN mkdir -p /opt/nifi/nifi-current/certs/elastic

# Generar el keystore y el certificado
RUN keytool -genkeypair -alias nifi -keyalg RSA -keysize 2048 -keystore /opt/nifi/nifi-current/certs/nifi-keystore.p12 -storepass gatvgatv -keypass gatvgatv -dname "CN=NiFi, OU=Dev, O=Org, L=City, S=State, C=Country" -storetype PKCS12 && \
    keytool -exportcert -alias nifi -keystore /opt/nifi/nifi-current/certs/nifi-keystore.p12 -storepass gatvgatv -file /opt/nifi/nifi-current/certs/nifi-cert.pem

# Cambiar de nuevo al usuario nifi para ejecutar el contenedor
USER nifi

# Especificar el comando por defecto para el contenedor
CMD ["nifi.sh", "run"]
