# gestion_datos_TFM

Instrucciones para levantar el stack de Elasticsearch, Kibana, NiFi y Nifi Registry (todos en docker-compose.yaml)

    ./start.sh siempre para lanzar los contenedores. Importante siempre usar ./start.sh para levantar los contenedores la primera vez o despes de un ./remove.sh
    ./stop.sh para detenerlos manteniendo la persistencia de los datos.
    ./remove.sh para borrar los contenedores y los datos.

En la caprpeta templates se encuentran los archivos de configuracion de los contenedores (archivo .env)



URLs de acceso a los servicios:

    Elasticsearch: http://localhost:9201
    Kibana: http://localhost:5601/
    NiFi: https://localhost:8443/nifi/
    Nifi Registry: http://localhost:18080/nifi-registry/

Levantar el servicio de Openmetada:

    docker-compose -f openemetadata/docker-compose-openmetadata.yaml up -d

Para acceder a la interfaz de Openmetadata:

    http://localhost:8585

    Usuario: admin@open-metadata.org
    Contraseña: admin

CASO DE LEVANTAR SOLO OPENMETADATA:
    Red de docker externalizada en docker compose de OpenMetadata. Cambiar a tipo bridge si solo se va a usar OpenMetadata.

