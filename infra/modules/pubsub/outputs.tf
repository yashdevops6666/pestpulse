output "topic_name" {
  value = google_pubsub_topic.device_events.name
}

output "subscription_name" {
  value = google_pubsub_subscription.device_events_sub.name
}
