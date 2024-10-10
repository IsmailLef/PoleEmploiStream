# SDTD Big Data Live-Streaming Readme

## Project Description

The SDTD Big Data Live-Streaming project is designed to handle the high volume of data coming from the Pôle Emploi job offers API. Given the substantial amount of incoming data, we utilize tools like Kafka and Cassandra to efficiently distribute and manage the database, ensuring both efficiency and resilience.

### Key Features:

- **Data Ingestion and Processing:**
  - The application continuously streams data from the Pôle Emploi API.
  - Kafka is used to handle the high throughput of incoming data, ensuring reliable and scalable data ingestion.
  - Cassandra is employed for its distributed database capabilities, providing high availability and fault tolerance.

- **Monitoring and Alerts:**
  - The application is monitored using Prometheus, which collects and stores metrics.
  - Grafana is used to visualize these metrics, providing insightful graphs and dashboards.
  - Alertmanager is configured to send alerts via hooks directly to Gmail, ensuring timely notifications of any issues.

- **Deployment and Scalability:**
  - The application is deployed on a Kubernetes cluster, adhering to a microservices architecture for better scalability and management.
  - Terraform is used to allocate resources on Google Cloud Platform (GCP), automating the infrastructure setup.
  - A manual auto-scaling tool has been developed to adjust resources dynamically based on the incoming workload, ensuring optimal performance.

### Project Goal:

The primary goal of the project is to capture all incoming job offer data, categorize it, and display it on a map to visualize its distribution. Additionally, the application provides various useful metrics to help analyze the data effectively.


## Launching the Cluster with Terraform

To launch the cluster, you must add your cloud access keys and run the following command:

```sh
terraform apply [--auto-approve]
```

**Note:** The script may take around ten minutes to complete. Once finished, all services will be available for use.

## Using the Application Locally

To use the application locally, follow these steps:

1. **Navigate to the project directory:**

    ```sh
    cd StreamnProcess/src/stream_pole_emploi
    ```

2. **Create a `.env` file for your credentials:**

    Use the information provided in the `.envexemple` file to create your `.env` file.

3. **Build the Docker images:**

    ```sh
    docker compose build
    ```

4. **Start the services:**

    ```sh
    docker compose up
    ```

5. **Access the application:**

    Wait until the data starts being inserted into the tables, then open the application at http://localhost:3001/.
