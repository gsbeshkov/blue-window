resource "random_id" "db_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  name             = "mysql-instance-${random_id.db_suffix.hex}"
  database_version = "MYSQL_8_0"
  region           = var.region
  project          = var.project_id
  
  
  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database" "app_db" {
  name     = "app_db"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "google_sql_user" "app_user" {
  name     = "php_user"
  instance = google_sql_database_instance.main.name
  password = var.db_password
  project  = var.project_id
}