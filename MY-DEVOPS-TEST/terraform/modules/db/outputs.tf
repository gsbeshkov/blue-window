output "connection_name" {
  description = "The connection name used by Cloud Run to connect to the DB"
  value       = google_sql_database_instance.main.connection_name
}

output "db_user" {
  description = "The database user"
  value       = google_sql_user.app_user.name
}

output "db_name" {
  description = "The database name"
  value       = google_sql_database.app_db.name
}