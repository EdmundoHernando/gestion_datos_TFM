# gestion_datos_TFM

Instrucciones para levantar el stack de Elasticsearch, Kibana, NiFi y Nifi Registry

    ./start.sh siempre para lanzar los contenedores. Importante siempre usar ./start.sh para levantar los contenedores la primera vez o despes de un ./remove.sh
    ./stop.sh para detenerlos manteniendo la persistencia de los datos.
    ./remove.sh para borrar los contenedores y los datos.

En la caprpeta templates se encuentran los archivos de configuracion de los contenedores (archivo .env)



URLs de acceso a los servicios:

    Elasticsearch: http://localhost:9200
    Kibana: http://localhost:5601/
    NiFi: http://localhost:8080/nifi/
    Nifi Registry: http://localhost:18080/nifi-registry/

Nombres de las imagenes:
    elaticsearch: es01 --> container name : elastic
    kibana: kibana 
    nifi: nifi --> container name : nifi_container_persistent
    nifi-registry: nifi-registry --> container name : registry_container_persistent

