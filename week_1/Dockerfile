FROM python:3.9

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app

COPY ingest_data.py ingest_data.py
COPY yellow_tripdata_2021-01.csv yellow_tripdata_2021-01.csv

# ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "python", "ingest_data.py" ]