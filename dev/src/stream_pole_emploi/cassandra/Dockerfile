# Pull cassandra image
FROM cassandra:latest

# Set Workdir
WORKDIR /etc/cassandra

# Expose port
EXPOSE 9042

# Copy cassandra configuration file 
COPY cassandra/cassandra.yaml .

# Start Cassandra in foreground mode
CMD ["cassandra", "-f"]
