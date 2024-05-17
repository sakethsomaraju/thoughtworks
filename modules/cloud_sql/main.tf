
#creating private vpc connection to connect to the sql instance with private-ip
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [var.private_ip_address_name]
}

#creation of sql instance with private ip in the custom vpc network
resource "google_sql_database_instance" "sql-instance" {
  name             = var.sql-instance-name
  region           = var.region
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.instance-tier

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = var.vpc_network_id
    }
  }

}

#creation of sql database in the sql instance
resource "google_sql_database" "database" {
  name     = var.sql_database_name
  instance = google_sql_database_instance.sql-instance.name
}

#creation of root user for the database
resource "google_sql_user" "users" {
  name     = "root"
  instance = google_sql_database_instance.sql-instance.name
  password = var.password

}