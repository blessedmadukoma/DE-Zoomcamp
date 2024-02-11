from time import time
import pandas as pd
from sqlalchemy import create_engine

username = "root"
password = "root"
host = "localhost"
port = "5432"
dbname = "ny_taxi_data_eng"

table_name = "hw_taxi_zone_data"
csv_name = "taxi+_zone_lookup.csv"

# connect to postgres db
engine = create_engine(f"postgresql://{username}:{password}@{host}:{port}/{dbname}")

# Read csv
df_iter = pd.read_csv(csv_name, iterator=True, chunksize=500)

df = next(df_iter)

engine.connect()

df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

t_start = time()

df.to_sql(name=table_name, con=engine, if_exists="append")

t_end = time()
print("first data ingested... took: %.3fs" % (t_end - t_start))

try:
  while True:
    t_start = time()
    df = next(df_iter)

    df.to_sql(name=table_name, con=engine, if_exists="append")

    t_end = time()

      
    print("another chunk ingested... took: %.3fs" % (t_end - t_start))

except StopIteration:
  print("End of file reached. Data ingestion complete!")
except Exception as e:
  print("Error: %s" % e)