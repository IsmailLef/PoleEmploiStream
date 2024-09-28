cp api_pole_emploi/Dockerfile .
sudo docker build -t api-pole-emploi:latest .
sudo docker tag api-pole-emploi:latest lefismail/api-pole-emploi:latest
sudo docker push lefismail/api-pole-emploi:latest

cp kafka_consumer/Dockerfile .
sudo docker build -t kafka-consumer:latest .
sudo docker tag kafka-consumer:latest lefismail/kafka-consumer:latest
sudo docker push lefismail/kafka-consumer:latest


cp cassandra_driver/Dockerfile .
sudo docker build -t cassandra_driver:latest .
sudo docker tag cassandra_driver:latest lefismail/cassandra_driver:latest
sudo docker push lefismail/cassandra_driver:latest
