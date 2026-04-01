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
