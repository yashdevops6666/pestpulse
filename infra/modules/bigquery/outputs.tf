output "dataset_id" {
  value = google_bigquery_dataset.pestpulse.dataset_id
}

output "table_id" {
  value = google_bigquery_table.device_events.table_id
}
