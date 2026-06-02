variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name to publish device events"
  type        = string
}
