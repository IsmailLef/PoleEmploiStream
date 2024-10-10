# DEV Big Data Live-Streaming and Data process

## Usage

1. **Navigate to the project directory:**

    ```sh
    cd src/stream_pole_emploi
    ```

2. **Create a `.env` file to specify your credentials:**

    Use the information provided in the `.envexemple` file to create your `.env` file.

3. **Build the Docker images defined in the Docker Compose configuration:**

    ```sh
    docker compose build
    ```

4. **Start the services defined in the Docker Compose file:**

    ```sh
    docker compose up
    ```

---

## Available Services

### Zookeeper

The Zookeeper service stores crucial data for Kafka's operation, such as the list of brokers, cluster configuration, and existing topics. Each broker registers with Zookeeper upon startup and regularly updates its status. Kafka clients can query Zookeeper to get the list of available brokers. This service uses the image `confluentinc/cp-zookeeper:latest` and exposes port 2181, which Kafka clients connect to for broker information.

### Kafka Broker

The Kafka Broker service uses the image `confluentinc/cp-kafka:latest` to create a Kafka broker, a node in the Kafka cluster responsible for storing and managing messages. This image provides a ready-to-use environment for running a Kafka broker in a Docker container. The Kafka service communicates with Zookeeper through port 2181 to get broker information and exposes port 9092 to allow the Kafka consumer service to connect to the Kafka broker from outside the container.

### API Pôle Emploi

The API Pôle Emploi service uses a Kafka producer to send data to a Kafka cluster. It periodically queries the Pôle Emploi API, retrieves data, and publishes it to the specified Kafka topic. It is configured to connect to the Kafka broker on port 9092.

### Kafka Consumer

The Kafka Consumer service uses a Kafka consumer to receive data from a Kafka cluster. This service is configured to listen to the specified Kafka topic and process the received messages. It communicates with the Kafka broker on port 9092 and also connects to Cassandra on port 9042 to store the received data.

### Cassandra

The Cassandra service uses the image `cassandra:latest` to create a Cassandra server in a Docker container. It exposes port 9042, which will be used by the Cassandra driver to connect to a Cassandra cluster.

### Cassandra Driver

The Cassandra Driver service establishes a connection with the database using port 9042. It performs initialization operations, such as creating schemas and inserting data, and prepares the Cassandra database for future interactions.
