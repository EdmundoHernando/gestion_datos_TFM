FROM apache/nifi:1.21.0

# Configurar permisos al inicio del contenedor
RUN chown -R nifi:nifi /opt/nifi/nifi-current && \
    chmod -R 777 /opt/nifi/nifi-current/logs && \
    chmod -R 777 /opt/nifi/nifi-current/conf

# Exponer el puerto https
EXPOSE 8443
