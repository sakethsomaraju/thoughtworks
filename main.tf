terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.20.0"
    }
  }
}
provider "google" {
  credentials = file("tf-key.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "terraform_remote_state" "remote_state" {
  backend = "gcs"

  config = {
    bucket      = var.remote_bucket_name
    prefix      = var.prefix_project
    credentials = file("tf-key.json")
  }
}

locals {
  prefix                        = "mediawiki"
  vpc-network-name              = format("%s-%s", local.prefix, var.vpc-network-name)
  subnet-name                   = format("%s-%s", local.prefix, var.subnet-name)
  ssh-firewall-name             = format("%s-%s", local.prefix, var.ssh_firewall_name)
  rotuer-name                   = format("%s-%s", local.prefix, var.router_name)
  nat-name                      = format("%s-%s", local.prefix, var.router_name)
  load-balancer-frontendip-name = format("%s-%s", local.prefix, var.load_balancer_frontendip_name)
  igmanager-name                = format("%s-%s", local.prefix, var.igmanager_name)
  base-instance-name            = format("%s-%s", local.prefix, var.base_instance_name)
  sql-instance-name             = format("%s-%s", local.prefix, var.sql-instance-name)
}


module "network" {
  source = "./modules/network"

  project_id = var.project_id

  vpc-network-name                          = local.vpc-network-name
  subnet-name                               = local.subnet-name
  subnet-ip-range                           = var.subnet-ip-range
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  health_check_firewall_name                = var.health_check_firewall_name
  health_check_firewall_description         = var.health_check_firewall_description
  health_check_firewall_direction           = var.health_check_firewall_direction
  ssh_firewall_name                         = local.ssh-firewall-name
  ssh_firewall_description                  = var.ssh_firewall_description
  ssh_firewall_direction                    = var.ssh_firewall_direction
  router_name                               = local.rotuer-name
  nat_name                                  = local.nat-name
  nat_ip_allocate_option                    = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat        = var.source_subnetwork_ip_ranges_to_nat
  filter                                    = var.filter
  vpc_reserving_ip_name                     = var.vpc_reserving_ip_name
  purpose                                   = var.purpose
  address_type                              = var.address_type
  ip_version                                = var.ip_version
  prefix_length                             = var.prefix_length
  load_balancer_frontendip_name             = local.load-balancer-frontendip-name
  load_balancer_forwarding_rule_name        = var.load_balancer_forwarding_rule_name
  load_balancer_forwarding_rule_ip_protocol = var.load_balancer_forwarding_rule_ip_protocol
  load_balancing_scheme                     = var.load_balancing_scheme
  load_balancer_forwarding_rule_port_range  = var.load_balancer_forwarding_rule_port_range
  load_balancer_http_proxy_name             = var.load_balancer_http_proxy_name
  load_balancer_url_map_name                = var.load_balancer_url_map_name
  load_balancer_backend_service_name        = var.load_balancer_backend_service_name
  load_balancer_backend_service_protocol    = var.load_balancer_backend_service_protocol
  load_balancer_backend_service_port_name   = var.load_balancer_backend_service_port_name
  timeout_sec                               = var.timeout_sec
  balancing_mode                            = var.balancing_mode
  capacity_scaler                           = var.capacity_scaler
  health_check_id                           = module.compute.health_check_id
  mig_id                                    = module.compute.mig_id
  health_check_firewall_protocol            = var.health_check_firewall_protocol
}

module "compute" {
  source = "./modules/compute"

  project_id                     = var.project_id
  zone                           = var.zone
  autoscaler_name                = var.autoscaler_name
  max_replicas                   = var.max_replicas
  min_replicas                   = var.min_replicas
  cooldown_period                = var.cooldown_period
  health_check_name              = var.health_check_name
  request_path                   = var.request_path
  check_interval_sec             = var.check_interval_sec
  timeout_sec                    = var.timeout_sec
  healthy_threshold              = var.healthy_threshold
  unhealthy_threshold            = var.unhealthy_threshold
  port                           = var.port
  igmanager_name                 = local.igmanager-name
  base_instance_name             = local.base-instance-name
  network_id                     = module.network.vpc_network_id
  subnetwork_id                  = module.network.vpc_subnetwork_id
  service_account_display_name   = var.service_account_display_name
  service_account_id             = var.service_account_id
  sql_admin_role                 = var.sql_admin_role
  secret_accessor_role           = var.secret_accessor_role
  source_reader_role             = var.source_reader_role
  editor_role                    = var.editor_role
  compute_admin_role             = var.compute_admin_role
  object_viwer_role              = var.object_viwer_role
  logging_admin_role             = var.logging_admin_role
  instance_admin_beta_role       = var.instance_admin_beta_role
  instance_admin_role            = var.instance_admin_role
  osAdminLogin_role              = var.osAdminLogin_role
  jumpserver_name                = var.jumpserver_name
  instance_template_machine_type = var.instance_template_machine_type
  instance_template_name         = var.instance_template_name
  cloudsql_ip                    = module.cloud_sql.sql-ip
  loadbalancer-public-ip         = module.network.loadbalancer-public-ip

}

module "cloud_sql" {
  source = "./modules/cloud_sql"

  sql-instance-name       = local.sql-instance-name
  vpc_network_id          = module.network.vpc_network_id
  region                  = var.region
  private_ip_address_id   = module.network.private_ip_address_id
  private_ip_address_name = module.network.private_ip_address_name
  sql_database_name       = var.sql_database_name
  instance-tier           = var.instance-tier
  password                = var.password
}