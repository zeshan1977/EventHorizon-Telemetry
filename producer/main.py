import time, json, random
from confluent_kafka import Producer

p = Producer({'bootstrap.servers': 'localhost:9092'})

def generate_telemetry():
    while True:
        data = {'sensor_id': 'reactor_core', 'temp': random.uniform(500.0, 1500.0)}
        p.produce('telemetry_stream', value=json.dumps(data))
        p.flush()
        print(f"Produced: {data}")
        time.sleep(1)

if __name__ == '__main__':
    generate_telemetry()
