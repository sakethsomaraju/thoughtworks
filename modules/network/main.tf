#creation of vpc-network with custom subnetwork

resource "google_compute_network" "vpc-network" {
  name                    = var.vpc-network-name
  routing_mode            = var.routing_mode
  auto_create_subnetworks = var.auto_create_subnetworks
}

#creation of the subnetwork in the previously created vpc-network
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet-name
  ip_cidr_range = var.subnet-ip-range
  region        = var.region
  network       = google_compute_network.vpc-network.id

}

#========================================================================================

#firewall rule to allow health check
resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = var.health_check_firewall_name
  network     = google_compute_network.vpc-network.id
  description = var.health_check_firewall_description

  allow {
    protocol = var.health_check_firewall_protocol
    ports    = ["80"]
  }

  direction     = var.ssh_firewall_direction
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]
  target_tags   = ["health-check"]
}
#firewall rule to allow ssh for troubleshooting and jumpserver accessing
resource "google_compute_firewall" "allow-ssh" {
  project     = var.project_id
  name        = var.ssh_firewall_name
  network     = google_compute_network.vpc-network.id
  description = var.ssh_firewall_description

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = var.ssh_firewall_direction
  source_ranges = ["35.235.240.0/20", "10.0.0.0/20"]
  target_tags   = ["allow-ssh"]
}

#====================================================================================


resource "google_compute_router" "router" {
  name    = var.router_name
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.vpc-network.id


  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = true
    filter = var.filter
  }
}
# =======================================================================================
#reserving the ip address range for  vpc-peering with google mangaed vpc to connect with the private-ip sql instance
resource "google_compute_global_address" "private_ip_address" {
  name          = var.vpc_reserving_ip_name
  purpose       = var.purpose
  address_type  = var.address_type
  ip_version    = var.ip_version
  prefix_length = 20
  network       = google_compute_network.vpc-network.self_link
}


#=========================================================================================


#reserving ip address for static load balancer frontend 
# reserved IP address
resource "google_compute_global_address" "default" {
  name = var.load_balancer_frontendip_name
}

#forwarding rule to fetch traffic from external users and forward it to the http proxy
#forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.load_balancer_forwarding_rule_name
  ip_protocol           = var.load_balancer_forwarding_rule_ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.load_balancer_forwarding_rule_port_range
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.address
}


# http proxy
resource "google_compute_target_http_proxy" "default" {
  name    = var.load_balancer_http_proxy_name
  url_map = google_compute_url_map.default.id
}

# #url map with the default backend service of MIGs
# # url map
resource "google_compute_url_map" "default" {
  name            = var.load_balancer_url_map_name
  default_service = google_compute_backend_service.default.id
}

#backend service of Managed instance group 
# backend service
resource "google_compute_backend_service" "default" {
  name                  = var.load_balancer_backend_service_name
  protocol              = var.load_balancer_backend_service_protocol
  port_name             = var.load_balancer_backend_service_port_name
  load_balancing_scheme = var.load_balancing_scheme
  timeout_sec           = var.timeout_sec
  health_checks         = [var.health_check_id]
  backend {
    group           = var.mig_id
    balancing_mode  = var.balancing_mode
    capacity_scaler = var.capacity_scaler
  }
}
