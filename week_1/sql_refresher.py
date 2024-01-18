from time import time
import pandas as pd
from sqlalchemy import create_engine

username = "root"
password = "root"
host = "localhost"
port = "5432"
dbname = "ny_taxi_data_eng"
table_name = "taxi_zone_data"

csv_name = "taxi+_zone_lookup.csv"

df = pd.read_csv(csv_name)

# connect to postgres db
engine = create_engine(f"postgresql://{username}:{password}@{host}:{port}/{dbname}")

engine.connect()

df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

try:
  t_start = time()

  df.to_sql(name=table_name, con=engine, if_exists="append")

  t_end = time()
    
  print("data ingested... took: %.3fs" % (t_end - t_start))

except:
  print("Data ingestion complete!")