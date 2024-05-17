#service account creation for the application instance template

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}


#providing sql admin role for the service account to get access to sql instance for building connection
resource "google_project_iam_member" "iam_user_cloudsql_instance_user" {
  project = var.project_id
  role    = var.sql_admin_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
#providing compute.admin permission for the SA to provide permission to create the vms and access the compute resources like mig
resource "google_project_iam_member" "iam_user_computeadmin_user" {
  project = var.project_id
  role    = var.compute_admin_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "iam_editor_user" {
  project = var.project_id
  role    = var.editor_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "iam_osadminlogin_user" {
  project = var.project_id
  role    = var.osAdminLogin_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "iam_iam_user" {

  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "iam_instance_admin_role" {

  project = var.project_id
  role    = var.instance_admin_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "iam_instance_admin_beta_role" {

  project = var.project_id
  role    = var.instance_admin_beta_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}



#==================================================================================


#instance template with startup script and terraform managed service account 


resource "google_compute_instance_template" "instance-template" {
  name         = var.instance_template_name
  machine_type = var.instance_template_machine_type
  tags         = ["health-check", "allow-ssh"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id
  }
  metadata = {
    "LOAD_BALANCER_IP" = var.loadbalancer-public-ip,
    "DATABASE_IP"      = var.cloudsql_ip
  }
  metadata_startup_script = file("modules/compute/startup_script.sh")
  service_account {
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }
  labels = {
    mediawiki = "mediawiki"
  }


}
#===================================================================================

#autoscaler with the default CPU 60% utilization metric

resource "google_compute_autoscaler" "default" {

  name   = var.autoscaler_name
  zone   = var.zone
  target = google_compute_instance_group_manager.appserver.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period


  }
}

#http health check for mig 

resource "google_compute_health_check" "autohealing" {
  name                = var.health_check_name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    port         = var.port
    request_path = var.request_path
  }
}

# mig creation with named port and health check
resource "google_compute_instance_group_manager" "appserver" {
  name = var.igmanager_name

  base_instance_name = var.base_instance_name
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.instance-template.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.self_link
    initial_delay_sec = 300
  }
}

resource "google_compute_instance" "jumpserver" {
  name         = var.jumpserver_name
  machine_type = var.instance_template_machine_type
  zone         = var.zone
  tags         = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id
  }

  service_account {

    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }
}