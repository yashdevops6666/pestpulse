resource "google_cloud_run_v2_service" "ingestion_api" {
  name     = "${var.environment}-pestpulse-ingestion"
  location = var.region
  project  = var.project_id

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/pestpulse/${var.environment}-ingestion:latest"

      env {
        name  = "PUBSUB_TOPIC"
        value = var.pubsub_topic_name
      }
      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "ENVIRONMENT"
        value = var.environment
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
  }

  labels = {
    environment = var.environment
    project     = "pestpulse"
  }
}
