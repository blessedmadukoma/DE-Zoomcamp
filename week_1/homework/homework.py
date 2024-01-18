from time import time
import pandas as pd
from sqlalchemy import create_engine
import os

username = "root"
password = "root"
host = "localhost"
port = "5432"
dbname = "ny_taxi_data_eng"
# table_name = "homework_data"
table_name = "green_trip_data"

# csv_name_1 = "taxi+_zone_lookup.csv"
csv_name_2 = "green_tripdata_2019-01.csv"

# df = pd.read_csv(csv_name)

# print(df.head(n=10))

# os.exit()

# handle first CSV: taxi zone lookup data
# df_iter = pd.read_csv(csv_name1, iterator=True, chunksize=500)

# handle second CSV:green_trip data
df_iter = pd.read_csv(csv_name_2, iterator=True, chunksize=100000)
# df = pd.read_csv(csv_name_2)

df = next(df_iter)

# df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
# df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

# connect to postgres db
engine = create_engine(f"postgresql://{username}:{password}@{host}:{port}/{dbname}")

engine.connect()

df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

df.to_sql(name=table_name, con=engine, if_exists="append")

try:
  while True:
    t_start = time()

    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    df.to_sql(name=table_name, con=engine, if_exists="append")

    t_end = time()

    df = next(df_iter)
      
    print("data ingested... took: %.3fs" % (t_end - t_start))

except:
  print("Data ingestion complete!")