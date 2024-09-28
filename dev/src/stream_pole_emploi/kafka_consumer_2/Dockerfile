# Pull Python Image
FROM python:3.8

# Set Workdir
WORKDIR /usr/src

# Copy Files
COPY kafka_consumer_2/requirements.txt .
COPY utils utils
COPY kafka_consumer_2/kafka_consumer_2.py .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run Python script to consume messages from Kafka
CMD ["python", "kafka_consumer_2.py"]
