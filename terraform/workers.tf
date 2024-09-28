variable "worker_count" {
  description = "Number of worker instances"
  type        = number
  default     = 1
}

resource "google_service_account" "worker_service_account" {
  account_id   = "kubernetes-worker"
  display_name = "Kubernetes Worker Service Account"
}

resource "google_project_iam_member" "worker_service_account_role" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.worker_service_account.email}"
}

resource "google_compute_instance" "k8s_worker" {
  count        = var.worker_count
  provider     = google-beta
  name         = "k8s-worker-instance-${count.index}"
  machine_type = "n1-standard-2"
  zone         = "${var.region}-c"
  tags         = ["worker-node", "${var.network}-firewall-ssh", "${var.network}-firewall-k8s"]
  depends_on   = [null_resource.master-init]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
      size  = 20
    }
  }
  can_ip_forward = false

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata = {
    ssh-keys       = "ubuntu:${file("./ssh/id_rsa.pub")}"
    startup-script = file("./k8s-worker-startup-script.sh")
  }

  service_account {
    email  = google_service_account.worker_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform", "userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "null_resource" "transfer-state" {
  depends_on = [google_compute_instance.k8s_worker]
  provisioner "remote-exec" {
    inline = [
      "bash script.sh"
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
      "bash ./Prometheus/helm-install.sh",
      "bash ./Prometheus/prometheus_install.sh",
      "bash ./Prometheus/kafka_exporter_install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/ssh/id_rsa")
      host        = google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip
    }
  }
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ./ssh/id_rsa -r ./terraform.tfstate* ubuntu@${google_compute_instance.k8s_master.network_interface.0.access_config.0.nat_ip}:/home/ubuntu/terraform"
  }
}
