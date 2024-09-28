# SDTD DEV



## Utilisation

1. Dirigez-vous vers le répertoire src/stream_pole_emploi :

```
cd src/stream_pole_emploi
```

2. Créez un fichier **.env** afin de spécifier vos informations d'identification. Vous pouvez utiliser les mêmes informations que celles fournies dans le fichier **.envexemple.**

3. Exécutez la commande suivante pour construire les images Docker définies dans la configuration Docker Compose :

```
docker compose build
```

4. Exécutez la commande suivante pour démarrer les services définis dans le fichier Docker Compose : 

```
docker compose up
```
***

# Les services présents

## zookeeper
Le service zookeeper stocke des données cruciales pour le bon fonctionnement de Kafka, telles que la liste des brokers, la configuration du cluster et les topics existants. Chaque broker s'inscrit auprès de Zookeeper lors de son démarrage et met régulièrement à jour son statut. Ainsi, les clients Kafka peuvent interroger Zookeeper pour obtenir la liste des brokers disponibles. Le service utilise l'image "confluentinc/cp-zookeeper:latest" et expose le port 2181 auquel les clients Kafka se connectent pour obtenir des informations sur les brokers disponibles.

## kafka-broker
Le service kafka-broker utilise l'image "confluentinc/cp-kafka:latest" pour créer un broker Kafka, qui est un nœud du cluster Kafka responsable du stockage et de la gestion des messages. Cette image offre un environnement prêt à l'emploi pour exécuter un broker Kafka dans un conteneur Docker. Le service Kafka communique avec Zookeeper à travers le port 2181 afin d'obtenir des informations sur les brokers disponibles. De plus, il expose le port 9092 pour permettre au service kafka-consumer de se connecter au broker Kafka depuis l'extérieur du conteneur.

## api-pole-emploi
Le service api-pole-emploi utilise un producteur Kafka pour envoyer des données vers un cluster Kafka. Il effectue des requêtes périodiques à l'API de Pôle Emploi, récupère les données, et les publie dans le sujet Kafka spécifié. Il est configuré pour se connecter au broker kafka-broker sur le port 9092.

## kafka-consumer 
Le service kafka-consumer utilise un consommateur Kafka pour recevoir des données à partir d'un cluster Kafka. Ce service est configuré pour écouter le sujet Kafka spécifié et traiter les messages reçus. Il communique avec le broker Kafka kafka-broker sur le port 9092 et établit également une connexion avec Cassandra sur le port 9042 pour stocker les données reçues.

## cassandra
Le service Cassandra utilise l'image "cassandra:latest" pour créer un serveur Cassandra dans un conteneur Docker. Il expose le port 9042 qui sera utilisé par le pilote Cassandra (Cassandra Driver) pour se connecter à un cluster Cassandra.

## cassandra-driver
Le service Cassandra driver établit une connexion avec la base de données en utilisant le port 9042. Ileffectue des opérations d'initialisation, telles que la création de schémas et l'insertion de données et prépare la base de données Cassandra pour les interactions futures.

