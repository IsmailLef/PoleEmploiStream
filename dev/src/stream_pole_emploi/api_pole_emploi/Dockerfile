# Pull Fython Image
FROM python:3.8

# Set Workdir
WORKDIR /usr/src

# Copy Files
COPY .env .
COPY api_pole_emploi/data_pole_emploi.py .
COPY api_pole_emploi/requirements.txt .

# Install Dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run Python Script to send data
CMD ["python", "data_pole_emploi.py"]