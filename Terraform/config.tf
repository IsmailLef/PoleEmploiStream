provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

resource "google_service_account" "master_service_account" {
  account_id   = "kubernetes-master"
  display_name = "Kubernetes Worker Service Account"
}

resource "google_project_iam_member" "master_service_account_storage_user_role" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.master_service_account.email}"
}

resource "google_compute_instance" "k8s_master" {
  provider     = google-beta
  name         = "k8s-master-instance"
  machine_type = "n1-standard-2"
  zone         = "${var.region}-c"
  tags         = ["master-node", "${var.network}-firewall-ssh", "${var.network}-firewall-k8s", "${var.network}-firewall-http", "${var.network}-firewall-https", "${var.network}-firewall-webhooks"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
      size  = 20
    }
  }
  can_ip_forward = "true"

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      // Assign public IP
      nat_ip = google_compute_address.k8s_master_public_ip.address
    }
    // Assign internal IP
    network_ip = google_compute_address.k8s_master_internal_ip.address
  }

  service_account {
    email  = google_service_account.master_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform", "userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata = {
    ssh-keys       = "ubuntu:${file("./ssh/id_rsa.pub")}"
    startup-script = file("./k8s-master-startup-script.sh")
  }
}

resource "null_resource" "master-init" {

  depends_on = [google_compute_instance.k8s_master]
  triggers = {
    master_ip = google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip
  }
  lifecycle {
    ignore_changes = [triggers]
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/terraform",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/ssh/id_rsa")
      host        = google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    command = "bash ./transfer.sh ${google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip}"
  }


  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/k8s_init_done ]; do sleep 10; done"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/ssh/id_rsa")
      host        = google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip
    }
  }


  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/terraform && terraform init"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/ssh/id_rsa")
      host        = google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip
    }
  }
}

