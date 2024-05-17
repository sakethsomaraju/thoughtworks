variable "region" {
  type    = string
  default = "us-central1"
}
variable "subnet-name" {
  type = string
}
variable "subnet-ip-range" {
  type = string
}


variable "vpc-network-name" {
  type = string
}

variable "project_id" {
  type = string
}
variable "health_check_id" {
  type = string
}
variable "mig_id" {
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
variable "health_check_firewall_protocol" {
  type = string
}