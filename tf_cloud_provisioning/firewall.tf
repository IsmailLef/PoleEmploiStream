# firewall.tf
## Create firewall for http(s)

resource "google_compute_firewall" "default_deny_rdp" {
  name        = "default-deny-rdp"
  network     = google_compute_network.default.name
  description = "deny default RDP from anywhere"
  priority    = "65533"

  deny {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_deny_icmp" {
  name        = "default-deny-icmp"
  network     = google_compute_network.default.name
  description = "deny default ICMP from anywhere"
  priority    = "65533"

  deny {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_allow_internal_traffic" {
  name        = "default-allow-internal-traffic"
  network     = google_compute_network.default.name
  description = "default allow internal traffic"
  priority    = "65533"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "${google_compute_subnetwork.default.ip_cidr_range}",
  ]
}

resource "google_compute_firewall" "ssh" {
  name     = "${var.network}-firewall-ssh"
  network  = google_compute_network.default.name
  priority = "65500"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["${var.network}-firewall-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name     = "${var.network}-firewall-http"
  network  = google_compute_network.default.name
  priority = "65500"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["${var.network}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
  name     = "${var.network}-firewall-https"
  network  = google_compute_network.default.name
  priority = "65500"


  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["${var.network}-firewall-https"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "k8s" {
  name     = "${var.network}-firewall-k8s"
  network  = google_compute_network.default.name
  priority = "65500"


  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  target_tags   = ["${var.network}-firewall-k8s"]
  source_ranges = ["10.243.0.0/16"]
}

resource "google_compute_firewall" "webhooks" {
  name     = "${var.network}-firewall-webhooks"
  network  = google_compute_network.default.name
  priority = "65500"


  allow {
    protocol = "tcp"
    ports    = ["5001", "30000"]
  }

  target_tags   = ["${var.network}-firewall-webhooks"]
  source_ranges = ["0.0.0.0/0"]
}
