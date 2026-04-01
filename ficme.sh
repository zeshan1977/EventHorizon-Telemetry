# 1. Write the Kafka Consumer (calculates rolling averages)
cat << 'EOF' > consumer/main.py
import json
from confluent_kafka import Consumer

c = Consumer({
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'telemetry_group',
    'auto.offset.reset': 'earliest'
})
c.subscribe(['telemetry_stream'])

def consume_stream():
    print("Consumer started. Waiting for events...")
    temp_history = []
    
    while True:
        msg = c.poll(1.0)
        if msg is None: continue
        if msg.error():
            print(f"Consumer error: {msg.error()}")
            continue
            
        data = json.loads(msg.value().decode('utf-8'))
        temp = data.get('temp', 0)
        
        # Calculate moving average of last 5 readings
        temp_history.append(temp)
        if len(temp_history) > 5:
            temp_history.pop(0)
            
        avg_temp = sum(temp_history) / len(temp_history)
        
        # Alert threshold
        alert = "WARNING!" if avg_temp > 1200 else "OK"
        print(f"[{alert}] Sensor: {data['sensor_id']} | Current: {temp:.2f} | 5-Tick Avg: {avg_temp:.2f}")

if __name__ == '__main__':
    consume_stream()
EOF

# 2. Write the Flask Dashboard (dashboard/app.py)
cat << 'EOF' > dashboard/app.py
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI(title="EventHorizon Dashboard")

@app.get("/", response_class=HTMLResponse)
def get_dashboard():
    return """
    <html>
        <head>
            <title>EventHorizon Telemetry</title>
            <style>
                body { background-color: #0f172a; color: #38bdf8; font-family: monospace; padding: 2rem; }
                h1 { color: #f8fafc; }
            </style>
        </head>
        <body>
            <h1>EventHorizon Telemetry Dashboard</h1>
            <p>Kafka Stream Consumer is running in the background.</p>
            <p>Check the Docker logs for real-time moving averages and thresholds.</p>
        </body>
    </html>
    """
EOF
