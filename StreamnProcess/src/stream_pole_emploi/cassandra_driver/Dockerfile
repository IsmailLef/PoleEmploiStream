# Pull Python Image
FROM python:3.8

# Set Workdir
WORKDIR /usr/src

# Copy Files
COPY .env .
COPY cassandra_driver/init_database.py .
COPY cassandra_driver/requirements.txt .
COPY api_pole_emploi/data_pole_emploi.py .
COPY utils utils

# Install Dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Cassandra Driver
RUN pip install cassandra-driver

# Run Python Script to init Database
CMD ["python", "-u", "init_database.py"]