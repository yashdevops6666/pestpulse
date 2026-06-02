import base64
import json
import os
from datetime import datetime
from google.cloud import bigquery

PROJECT_ID = os.environ.get("PROJECT_ID", "pestpulse")
DATASET_ID = os.environ.get("DATASET_ID", "dev_pestpulse")
TABLE_ID = os.environ.get("TABLE_ID", "device_events")

client = bigquery.Client()

def process_device_event(event, context):
    try:
        message = base64.b64decode(event["data"]).decode("utf-8")
        data = json.loads(message)

        row = {
            "device_id": data["device_id"],
            "device_type": data["device_type"],
            "location": data["location"],
            "event_type": data["event_type"],
            "severity": data.get("severity"),
            "temperature": data.get("temperature"),
            "battery_level": data.get("battery_level"),
            "timestamp": data.get("received_at", datetime.utcnow().isoformat()),
            "processed_at": datetime.utcnow().isoformat(),
            "raw_payload": message
        }

        table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"
        errors = client.insert_rows_json(table_ref, [row])

        if errors:
            print(f"BigQuery insert errors: {errors}")
        else:
            print(f"Successfully inserted event for device {data['device_id']}")

    except Exception as e:
        print(f"Error processing event: {str(e)}")
        raise
