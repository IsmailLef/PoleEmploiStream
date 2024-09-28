## GET DNS ZONE from gloud named euw-zone, and add a record for website domain
resource "random_id" "rnd" {
  byte_length = 4
}

resource "google_dns_managed_zone" "dns_zone" {
  name        = "us-zone"
  dns_name    = "us-${random_id.rnd.hex}.com."
}

resource "google_dns_record_set" "website" {
  name = "website.${resource.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = resource.google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_address.k8s_master_public_ip.address]
}

## Create a vpc network for nodes

resource "google_compute_network" "default" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "default" {
  name          = "terraform-subnetwork-k8s-int"
  network       = google_compute_network.default.id
  ip_cidr_range = var.pod_cidr
}


## STATIC IP addresses for master node (regionals)

resource "google_compute_address" "k8s_master_public_ip" {
  name = "k8s-master-ip-ext"
}

resource "google_compute_address" "k8s_master_internal_ip" {
  name         = "k8s-master-ip-int"
  subnetwork   = google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  address      = "10.243.0.2"
}
