import json
import time
from offres_emploi import Api
from offres_emploi.utils import dt_to_str_iso as str_iso
from datetime import datetime, timedelta
from decouple import config
from kafka import KafkaProducer

CLIENT_ID = config('CLIENT_ID')
CLIENT_SECRET = config('CLIENT_SECRET')

BOOTSTRAP_SERVERS = ['kafka-broker-1:9092']
TOPIC_NAME = 'jobs'

CLIENT_API = Api(CLIENT_ID, CLIENT_SECRET)

PRODUCER = KafkaProducer(bootstrap_servers=BOOTSTRAP_SERVERS,
                         api_version=(0,0,2),
                         value_serializer= lambda v: json.dumps(v).encode('utf-8'))

NO_DATA_ERROR = "'NoneType' object has no attribute 'groupdict'"
MAX_POSSIBLE_RESULTS = 3150

def get_jobs():
    # A simple request to get the offers in the last 10 minutes
    current = datetime.today()
    previous = current - timedelta(minutes=10)
    params = {
        'minCreationDate': str_iso(previous),
        'maxCreationDate': str_iso(current)
    }
    try:
        jobs = CLIENT_API.search(params=params)
        max_results = int(jobs['Content-Range']['max_results'])
        if (max_results >= 150):
            paginate_data(params, max_results)
    except Exception as error:
        if (str(error) == NO_DATA_ERROR):
            print(f'\033[1m\033[93mNo data from {previous} to {current}\033[0m')
        else:
            print(f'\033[1m\033[91m{error}\033[0m')
    return jobs

def paginate_data(params, max_results):
    if (max_results >= MAX_POSSIBLE_RESULTS):
        print(f'\033[1m\033[93mData may be overload: API limit reached !\033[0m')
    step = 149
    current = 150
    while current < min(max_results, MAX_POSSIBLE_RESULTS):
        next = min(current + step, max_results - 1)
        params["range"] = f'{current}-{next}'
        jobs = CLIENT_API.search(params=params)
        try:
            PRODUCER.send(TOPIC_NAME, jobs)
        except Exception as error:
            print(f'\033[1m\033[91m{error}\033[0m')
        current = next + 1
    print("\033[1m\033[92mSuccessfully sent paginated data !\033[0m")

def send_data(start, end, interval=10):
    current = start
    while current < end:
        next = current + timedelta(minutes=interval)
        params = {
            'minCreationDate': str_iso(current),
            'maxCreationDate': str_iso(next)
        }
        try:
            jobs = CLIENT_API.search(params=params)
            max_results = int(jobs['Content-Range']['max_results'])
            if (max_results > 150):
                print(f'Sending {max_results} data from {current} to {next} with pagination ...')
                PRODUCER.send(TOPIC_NAME, jobs)
                paginate_data(params, max_results)
            else:
                print(f'Sending data from {current} to {next} ...')
                PRODUCER.send(TOPIC_NAME, jobs)
                print("\033[1m\033[92mSuccessfully sent !\033[0m")
        except Exception as error:
            if (str(error) == NO_DATA_ERROR):
                print(f'\033[1m\033[93mNo data from {current} to {next}\033[0m')
            else:
                print(f'\033[1m\033[91m{error}\033[0m')
        current = next

if __name__ == '__main__':
    send_data(datetime(2023, 12, 1, 0, 0), datetime.now(), 10)
    while True:
        current = datetime.now()
        send_data(current - timedelta(minutes=10), current, 10)
        print("Sleep for 10 minutes ...")
        time.sleep(600)
    # while True:
    #     try:
    #         PRODUCER.send(TOPIC_NAME, get_jobs())
    #         print("Sleep for 10 seconds ...")
    #         time.sleep(10)
    #     except Exception as error:
    #         print(f'Error: {error}')