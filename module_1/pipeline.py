import sys

import pandas as pd

print(sys.argv)

day = sys.argv[1]

# some fancy stuff with pandas

print('job finished successfully for day = {day}')

# docker run -it \
#   -e POSTGRES_USER="root" \
#   -e POSTGRES_PASSWORD="root" \
#   -e POSTGRES_DB="ny_taxi_data_eng" \
#   -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
#   -p 5432:5432 \
#   --name DE_zoomcamp \
#   postgres:14-alpine

# NYC Taxi data: https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page

# pull pgadmin: docker pull dpage/pgadmin4
# docker run -it \
#   -e PGADMIN_DEFAULT_EMAIL="blessedmadukoma@gmail.com" \
#   -e PGADMIN_DEFAULT_PASSWORD="blessed10" \
#   -p 9090:80 \
#   --name my_pgadmin4 \
#   dpage/pgadmin4


# docker network
# create a network
# docker network create pg-data-network

# updated postgres docker command
# docker run -it \
#   -e POSTGRES_USER="root" \
#   -e POSTGRES_PASSWORD="root" \
#   -e POSTGRES_DB="ny_taxi_data_eng" \
#   -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
#   -p 5432:5432 \
#   --network=pg-data-network \
#   --name DE_zoomcamp \
#   postgres:14-alpine

# OR!!!

# docker network connect pg-data-network DE_zoomcamp

# FOR PGAdmin
# docker network connect pg-data-network my_pgadmin4

# Ingest the data
# URL = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv"
# python ingest_data.py \
#   --user=root \
#   --password=root \
#   --host=localhost \
#   --port=5432 \
#   --dbname=ny_taxi_data_eng \
#   --table_name=yellow_taxi_data \
#   --url=${URL}

# docker run -it \
#   --network=pg-data-network \
#   --name=data_eng_ingest
#   de_taxi_ingest:v001 \
#     --user=root \
#     --password=root \
#     --host=DE_zoomcamp \
#     --port=5432 \
#     --dbname=ny_taxi_data_eng \
#     --table_name=yellow_taxi_data \
#     --url=${URL}
