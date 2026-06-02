import os
import json
import logging
from datetime import datetime
from flask import Flask, request, jsonify
from google.cloud import pubsub_v1

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

PROJECT_ID = os.environ.get("PROJECT_ID", "pestpulse")
PUBSUB_TOPIC = os.environ.get("PUBSUB_TOPIC", "dev-device-events")
ENVIRONMENT = os.environ.get("ENVIRONMENT", "dev")

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(PROJECT_ID, PUBSUB_TOPIC)

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy", "environment": ENVIRONMENT}), 200

@app.route("/ingest", methods=["POST"])
def ingest():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No data provided"}), 400

        required_fields = ["device_id", "device_type", "location", "event_type"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing field: {field}"}), 400

        data["received_at"] = datetime.utcnow().isoformat()
        data["environment"] = ENVIRONMENT

        message = json.dumps(data).encode("utf-8")
        future = publisher.publish(topic_path, message)
        message_id = future.result()

        logging.info(f"Published message {message_id} for device {data['device_id']}")

        return jsonify({
            "status": "accepted",
            "message_id": message_id,
            "device_id": data["device_id"]
        }), 202

    except Exception as e:
        logging.error(f"Error ingesting event: {str(e)}")
        return jsonify({"error": "Internal server error"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
