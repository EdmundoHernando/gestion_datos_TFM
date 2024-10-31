# Usa la imagen base de NiFi
FROM apache/nifi:1.14.0

# Cambiar al usuario root para permitir cambios de permisos
USER root

# Copiar el script de generación de certificados al contenedor
COPY generate-certs.sh /opt/nifi/scripts/generate-certs.sh

# Asegurarse de que el script tenga permisos de ejecución
RUN chmod +x /opt/nifi/scripts/generate-certs.sh

# Cambiar de nuevo al usuario nifi para ejecutar el contenedor
USER nifi

# Ejecutar el script de generación de certificados
RUN /opt/nifi/scripts/generate-certs.sh

# Especificar el comando por defecto para el contenedor
CMD ["nifi.sh", "run"]
