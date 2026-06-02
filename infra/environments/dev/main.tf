terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "pestpulsetfstate"
    prefix = "dev"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "pubsub" {
  source      = "../../modules/pubsub"
  project_id  = var.project_id
  environment = "dev"
}

module "bigquery" {
  source      = "../../modules/bigquery"
  project_id  = var.project_id
  environment = "dev"
  region      = var.region
}

module "cloudrun" {
  source            = "../../modules/cloudrun"
  project_id        = var.project_id
  environment       = "dev"
  region            = var.region
  pubsub_topic_name = module.pubsub.topic_name
}

output "ingestion_api_url" {
  value = module.cloudrun.service_url
}

output "pubsub_topic" {
  value = module.pubsub.topic_name
}

output "bigquery_dataset" {
  value = module.bigquery.dataset_id
}
