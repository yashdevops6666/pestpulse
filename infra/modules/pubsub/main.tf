resource "google_pubsub_topic" "device_events" {
  name    = "${var.environment}-device-events"
  project = var.project_id

  message_retention_duration = "86600s"

  labels = {
    environment = var.environment
    project     = "pestpulse"
  }
}

resource "google_pubsub_subscription" "device_events_sub" {
  name    = "${var.environment}-device-events-sub"
  topic   = google_pubsub_topic.device_events.name
  project = var.project_id

  ack_deadline_seconds = 20

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  labels = {
    environment = var.environment
    project     = "pestpulse"
  }
}
