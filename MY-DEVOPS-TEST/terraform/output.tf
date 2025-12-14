# ---------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------
output "load_balancer_ip" {
  description = "The public IP of the Load Balancer"
  value       = google_compute_global_forwarding_rule.default.ip_address
}

output "cloud_run_url" {
  description = "The direct URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.app.uri
}

output "bucket_name" {
  value = google_storage_bucket.static_assets.name
}