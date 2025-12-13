resource "google_cloud_run_service" "app" {
  name     = "php-app"
  location = var.region

  template {
    spec {
      containers {
        image = var.image

        env {
          name  = "STATIC_BUCKET"
          value = var.bucket_name
        }

        env {
          name  = "DB_CONNECTION"
          value = var.db_connection
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.app.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

