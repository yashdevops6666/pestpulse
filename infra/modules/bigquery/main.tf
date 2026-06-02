resource "google_bigquery_dataset" "pestpulse" {
  dataset_id  = "${var.environment}_pestpulse"
  project     = var.project_id
  location    = var.region
  description = "PestPulse IoT device events dataset"

  labels = {
    environment = var.environment
    project     = "pestpulse"
  }
}

resource "google_bigquery_table" "device_events" {
  dataset_id          = google_bigquery_dataset.pestpulse.dataset_id
  table_id            = "device_events"
  project             = var.project_id
  deletion_protection = false

  labels = {
    environment = var.environment
    project     = "pestpulse"
  }

  schema = jsonencode([
    {
      name = "device_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "device_type"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "location"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "event_type"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "severity"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "temperature"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "battery_level"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "processed_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "raw_payload"
      type = "STRING"
      mode = "NULLABLE"
    }
  ])
}
