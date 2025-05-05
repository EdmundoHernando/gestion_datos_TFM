#bin/bash
docker compose -f postgres/docker-compose-postgres.yaml down
docker compose -f openmetadata/docker-compose-openmetadata.yaml down
docker compose -f docker-compose.yaml down