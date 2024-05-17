variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "project_id" {
  type = string
}

variable "prefix_project" {
  type = string
}

variable "remote_bucket_name" {
  type = string
}
variable "routing_mode" {
  type = string
}
variable "health_check_firewall_name" {
  type = string
}
variable "health_check_firewall_description" {
  type = string
}
variable "health_check_firewall_direction" {
  type = string
}
variable "ssh_firewall_name" {
  type = string
}
variable "ssh_firewall_description" {
  type = string
}
variable "ssh_firewall_direction" {
  type = string
}
variable "router_name" {
  type = string
}
variable "nat_name" {
  type = string
}
variable "nat_ip_allocate_option" {
  type = string
}
variable "source_subnetwork_ip_ranges_to_nat" {
  type = string
}
variable "filter" {
  type = string
}
variable "vpc_reserving_ip_name" {
  type = string
}
variable "purpose" {
  type = string
}
variable "address_type" {
  type = string
}
variable "ip_version" {
  type = string
}
variable "prefix_length" {
  type = string
}
variable "load_balancer_frontendip_name" {
  type = string
}
variable "load_balancer_forwarding_rule_name" {
  type = string
}
variable "load_balancer_forwarding_rule_ip_protocol" {
  type = string
}
variable "load_balancing_scheme" {
  type = string
}
variable "load_balancer_forwarding_rule_port_range" {
  type = string
}
variable "load_balancer_http_proxy_name" {
  type = string
}
variable "load_balancer_url_map_name" {
  type = string
}
variable "load_balancer_backend_service_name" {
  type = string
}
variable "load_balancer_backend_service_protocol" {
  type = string
}
variable "load_balancer_backend_service_port_name" {
  type = string
}
variable "balancing_mode" {
  type = string
}
variable "capacity_scaler" {
  type = number
}

variable "timeout_sec" {
  type = number
}
variable "auto_create_subnetworks" {
  type = bool
}
variable "vpc-network-name" {
  type = string
}
variable "subnet-name" {
  type = string
}
variable "subnet-ip-range" {
  type = string
}
variable "health_check_firewall_protocol" {
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
variable "autoscaler_name" {
  type = string
}
variable "health_check_name" {
  type = string
}
variable "request_path" {
  type = string
}
variable "igmanager_name" {
  type = string
}
variable "base_instance_name" {
  type = string
}
variable "service_account_display_name" {
  type = string
}
variable "service_account_id" {
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
variable "check_interval_sec" {
  type = number
}
variable "check_timeout_sec" {
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
variable "password" {
  type = string
}
variable "sql-instance-name" {
  type = string
}
variable "sql_database_name" {
  type = string
}
variable "instance-tier" {
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