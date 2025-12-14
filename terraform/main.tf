resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = false
}

resource "time_sleep" "wait_for_apis" {
  depends_on = [google_project_service.apis]
  create_duration = "30s"
}

module "db" {
  source      = "./modules/db"
  project_id  = var.project_id
  region      = var.region
  db_password = var.db_password
  
  depends_on = [time_sleep.wait_for_apis]
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "static_assets" {
  name          = "static-assets-${random_id.bucket_suffix.hex}"
  location      = var.region
  force_destroy = true 
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = google_storage_bucket.static_assets.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_cloud_run_v2_service" "app" {
  name     = "php-app-service"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      
      ports {
        container_port = 8080
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "DB_CONNECTION_NAME"
        value = module.db.connection_name
      }
      env {
        name  = "DB_USER"
        value = module.db.db_user
      }
      env {
        name  = "DB_NAME"
        value = module.db.db_name
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [module.db.connection_name]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image
    ]
  }

  depends_on = [module.db, time_sleep.wait_for_apis]
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.app.name
  location = google_cloud_run_v2_service.app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Serverless NEG
resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "app-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_v2_service.app.name
  }
}

resource "google_compute_backend_service" "default" {
  name        = "app-backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
  depends_on = [time_sleep.wait_for_apis]
}

resource "google_compute_url_map" "default" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "app-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}
