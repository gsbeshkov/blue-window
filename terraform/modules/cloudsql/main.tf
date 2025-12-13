resource "google_sql_database_instance" "mysql" {
  name             = "mysql-${var.db_name}"
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.mysql.name
}

