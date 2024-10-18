# gestion_datos_TFM
Primera parte dond realizamos un compose de de elaticsearch, kibana y logstash.



Elasticsearch: http://localhost:9200
Logstash: http://localhost:9600
Kibana: http://localhost:5601/api/status

Para dar permisos a elatic y poder hacer mount bind de los volumenes:

    mkdir esdatadir
    chmod g+rwx esdatadir
    chgrp 0 esdatadir

Hacer los ./ a los volumenes e incluirlos en el .gitignore para hacer el commit
Crear rama dev en github 
Buscar catalogo de datos OS y compatibles con elastic
Mirar seguridad OAuth2 (Keycloak)