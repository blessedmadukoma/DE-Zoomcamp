import pandas as pd
from sqlalchemy import create_engine
from time import time
import argparse, os

def main(params):
  user  = params.user
  password  = params.password
  host  = params.host
  port  = params.port
  dbname  = params.dbname # ny_taxi_data_eng
  table_name  = params.table_name # 'yellow_taxi_data'
  url  = params.url

  csv_name = 'yellow_tripdata_2021-01.csv'
  # csv_name = 'output.csv'

  # download the csv
  # os.system(f"wget {url} -O {csv_name}")

  # Connect to Postgres
  # engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi_data_eng')
  engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{dbname}')

  # read data from csv
  # df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100, iterator=True, chunksize=100000)
  df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

  df = next(df_iter)

  # convert some fields from text to TIMESTAMP
  df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
  df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)

  engine.connect()

  # generate a schema (to create the table), connect to the database and run the generated query
  # get the table names (the first record) and insert into the database
  df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

  # get the rest of the data and insert
  df.to_sql(name=table_name, con=engine, if_exists='append')

  # keep inserting until everything is done
  while True:
    t_start = time()
    df = next(df_iter)

    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)

    df.to_sql(name=table_name, con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk... took %.3fs' % (t_end - t_start))

if __name__ == '__main__':
  parser = argparse.ArgumentParser(prog='NY Taxi Data Ingestion', description='Ingest CSV data to Postgres')

  parser.add_argument('--user', help='username for postgres')           
  parser.add_argument('--password', help='password for postgres') 
  parser.add_argument('--host', help='host for postgres') 
  parser.add_argument('--port', help='port for postgres') 
  parser.add_argument('--dbname', help='database name for postgres') 
  parser.add_argument('--table_name', help='table name for postgres') 
  parser.add_argument('--url', help='url of csv file')

  args = parser.parse_args()

  main(args)