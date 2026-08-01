terraform {
  required_version = ">= 1.3.0"
  backend "gcs" {
    bucket = "8bitcitychamp-tfstate-bitcitychamp-project"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Dedicated VPC Network
resource "google_compute_network" "eightbitcitychamp_vpc" {
  name                    = "v8bitcitychamp-vpc"
  auto_create_subnetworks = false
  description             = "Dedicated VPC network for 8bitCityChamp project"
}

# Dedicated Subnetwork
resource "google_compute_subnetwork" "eightbitcitychamp_subnet" {
  name          = "v8bitcitychamp-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.eightbitcitychamp_vpc.id
}

# Firewall Rule: Allow HTTP Traffic on Port 80
resource "google_compute_firewall" "eightbitcitychamp_firewall_http" {
  name    = "v8bitcitychamp-firewall-http"
  network = google_compute_network.eightbitcitychamp_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["8bitcitychamp-web"]
}

# Firewall Rule: Allow SSH Traffic on Port 22
resource "google_compute_firewall" "eightbitcitychamp_firewall_ssh" {
  name    = "v8bitcitychamp-firewall-ssh"
  network = google_compute_network.eightbitcitychamp_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["8bitcitychamp-web"]
}

# Static External Public IP Address
resource "google_compute_address" "eightbitcitychamp_ip" {
  name   = "v8bitcitychamp-ip"
  region = var.region
}

# Compute Engine VM Instance (e2-micro, Debian 12)
resource "google_compute_instance" "eightbitcitychamp_vm" {
  name         = "v8bitcitychamp-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["8bitcitychamp-web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.eightbitcitychamp_subnet.id

    access_config {
      nat_ip = google_compute_address.eightbitcitychamp_ip.address
    }
  }

  metadata_startup_script = file("${path.module}/scripts/startup.sh")

  labels = {
    project    = "8bitcitychamp"
    env        = var.environment
    managed_by = "terraform"
  }
}
