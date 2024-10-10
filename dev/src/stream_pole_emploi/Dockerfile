# Pull Python Image
FROM python:3.8

# Set Workdir
WORKDIR /usr/src

# Copy Files
COPY kafka_consumer/requirements.txt .
COPY utils utils
COPY kafka_consumer/kafka_consumer.py .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run Python script to consume messages from Kafka
CMD ["python", "kafka_consumer.py"]
