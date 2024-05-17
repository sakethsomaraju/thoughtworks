output "sql-ip" {
  value = google_sql_database_instance.sql-instance.ip_address.0.ip_address
}