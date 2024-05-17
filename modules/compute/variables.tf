variable "network_id" {
  type = string
}
variable "subnetwork_id" {
  type = string
}
variable "service_account_id" {
  type = string
}
variable "service_account_display_name" {
  type = string
}
variable "project_id" {
  type = string
}
variable "autoscaler_name" {
  type = string
}
variable "zone" {
  type = string
}
variable "max_replicas" {
  type = number
}
variable "min_replicas" {
  type = number
}
variable "cooldown_period" {
  type = number
}
variable "health_check_name" {
  type = string
}
variable "check_interval_sec" {
  type = number
}
variable "timeout_sec" {
  type = number
}
variable "healthy_threshold" {
  type = number
}
variable "unhealthy_threshold" {
  type = number
}
variable "port" {
  type = number
}
variable "igmanager_name" {
  type = string
}
variable "base_instance_name" {
  type = string
}
variable "request_path" {
  type = string
}
variable "sql_admin_role" {
  type = string
}
variable "secret_accessor_role" {
  type = string
}
variable "logging_admin_role" {
  type = string
}
variable "source_reader_role" {
  type = string
}
variable "compute_admin_role" {
  type = string
}
variable "object_viwer_role" {
  type = string
}
variable "editor_role" {
  type = string
}
variable "instance_admin_beta_role" {
  type = string
}
variable "instance_admin_role" {
  type = string
}
variable "osAdminLogin_role" {
  type = string
}
variable "instance_template_name" {
  type = string
}
variable "instance_template_machine_type" {
  type = string
}

variable "jumpserver_name" {
  type = string
}

variable "cloudsql_ip" {
  type = string
}

variable "loadbalancer-public-ip" {
  type = string
}