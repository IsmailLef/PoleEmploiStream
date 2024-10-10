from kafka import KafkaConsumer
from utils.cassandra_utils import *
from cassandra.cluster import Cluster
from cassandra.policies import DCAwareRoundRobinPolicy

import json
import os

# Kafka parameters
BOOTSTRAP_SERVERS = os.environ.get('BOOTSTRAP_SERVERS')
TOPIC_NAME = os.environ.get('TOPIC_NAME')
GROUP_ID = os.environ.get('GROUP_ID')

# Cassandra parameters
cassandra_hosts = os.environ.get('CASSANDRA_HOSTS', 'cassandra')
CLUSTER = Cluster([cassandra_hosts])
SESSION = CLUSTER.connect()
KEYSPACE = os.environ.get('KEYSPACE', 'offresEmploi')

def treat_data(data):
   json_data = json.loads(data)
   jobs = json_data["resultats"]
   for job in jobs:
      insert_data(SESSION, job)


def consumer_kafka():

   consumer = KafkaConsumer(
      TOPIC_NAME,
      bootstrap_servers=BOOTSTRAP_SERVERS,
      group_id=GROUP_ID
   )

   try:
      for message in consumer:
         treat_data(message.value)
   except Exception as e:
      print(f'Erreur: {e}')


if __name__ == "__main__":    
   # Set keyspace into session
   set_keyspace(SESSION, KEYSPACE.lower())
   
   # Begin consuming
   consumer_kafka()