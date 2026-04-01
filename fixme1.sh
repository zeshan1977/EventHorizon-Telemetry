# 1. Kill the background Python scripts so they stop spamming errors
pkill -f "python producer/main.py"
pkill -f "python consumer/main.py"

# 2. Overwrite the docker-compose with the strict KRaft requirements
cat << 'EOF' > docker-compose.yml
services:
  kafka:
    image: confluentinc/cp-kafka:7.5.0
    container_name: eventhorizon-kafka
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      CLUSTER_ID: 'MkU3OEVBNTcwNTJENDM2Qk'
    ports:
      - "9092:9092"
EOF

# 3. Destroy the crashed container and start a fresh one
sudo docker compose down
sudo docker compose up -d

echo "Waiting 10 seconds for Kafka to elect a leader..."
sleep 10

# 4. Start the Python streams again
nohup python producer/main.py > producer.log 2>&1 &
nohup python consumer/main.py > consumer.log 2>&1 &

echo "Done! Run: tail -f consumer.log to see the data stream!"
