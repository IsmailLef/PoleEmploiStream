from data_pole_emploi import CLIENT_API
from cassandra.cluster import Cluster
from utils.cassandra_utils import *
import time

def init_database():

   # Try connecting to Cassandra 
   max_attempts = 30
   for attempt in range(max_attempts):
      try:
         cluster = Cluster(['cassandra'])  
         session = cluster.connect()
         session.execute("SELECT * FROM system.local")
         print("\033[1m\033[92mCassandra is ready ...\033[0m"
)
         break
      except Exception as e:
         print(f"\033[1m\033[93mAttempt {attempt + 1}/{max_attempts}: Cassandra not ready, retrying...\033[0m")
         time.sleep(5)  
   else:
      print("Timed out waiting for Cassandra.")

   keyspace = "offresEmploi"

   # Create keyspace
   create_keyspace(session, keyspace)
    
   # Set keyspace into session
   set_keyspace(session, keyspace.lower())

   # Create jobs table
   create_jobs(session)
   
   # Create communes data
   communes = CLIENT_API.referentiel("communes")
   departements = CLIENT_API.referentiel("departements")
   create_departements(session, departements)
   create_communes(session, communes)

   # Close the session and the cluster
   session.shutdown()
   cluster.shutdown()

if __name__ == "__main__":
   init_database()
