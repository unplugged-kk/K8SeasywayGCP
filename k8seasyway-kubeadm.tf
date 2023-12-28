
#Creation of VPC NW 

resource "google_compute_network" "vpc_network" {
  name = "k8s-infra"
  auto_create_subnetworks = "false"
}

#Creation of subnet 

resource "google_compute_subnetwork" "k8s-infra-subnet" {
  name          = "k8s-subnet1"
  ip_cidr_range = "10.240.0.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id

  secondary_ip_range {
        range_name    = "pod-cidr"
        ip_cidr_range = "10.241.0.0/16"
  }
}

#Firewall Creation

resource "google_compute_firewall" "gcp-fw" {
  name    = "k8s-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22","443","80","8080","9090","9000-10000","30000-40000","5601","6443"]
  }

  target_tags = ["k8s-infra","default-node-pool"]
  source_ranges = ["0.0.0.0/0"]
}

# Public IP Creation#

resource "google_compute_address" "vm_static_ip_master" {
  name = "k8smaster-ip"
}

resource "google_compute_address" "vm_static_ip_worker1" {
  name = "k8sworker1-ip"
}

resource "google_compute_address" "vm_static_ip_worker2" {
  name = "k8sworker2-ip"
}

# Public IP Output #

output "out_master_pub_ip" {
    value = google_compute_address.vm_static_ip_master.address
}

output "out_worker1_pub_ip" {
    value = google_compute_address.vm_static_ip_worker1.address
}

output "out_worker2_pub_ip" {
    value = google_compute_address.vm_static_ip_worker2.address
}

# Instance creation K8S Master

resource "google_compute_instance" "master" {
  name         = "k8s-master"
  machine_type = "e2-medium"
  zone         = var.zone
  can_ip_forward       = true
  tags = ["k8s-infra"]
  

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.k8s-infra-subnet.name
    network_ip = "10.240.0.10"
    access_config {
      nat_ip = google_compute_address.vm_static_ip_master.address
    }
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220419"
      size = 30
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  
  metadata = {
   ssh-keys = "kishore:${file("~/.ssh/id_rsa.pub")}"
 } 

# We connect to our instance via Terraform and remotely executes our script using SSH 
  provisioner "file" {
    source      = "/Users/kishore/Desktop/Tools/SYLER_GITHUB/K8SeasywayGCP/scripts/latest/k8smaster_bootstrap.sh"
    destination = "/tmp/k8smaster_bootstrap.sh"
    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_master.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/k8smaster_bootstrap.sh",
      "sudo bash /tmp/k8smaster_bootstrap.sh",
    ]

    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_master.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }
}

# Instance creation K8S Worker1

resource "google_compute_instance" "worker1" {
  name         = "k8s-worker1"
  machine_type = "e2-medium"
  zone         = var.zone
  can_ip_forward       = true
  tags = ["k8s-infra"]
  

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.k8s-infra-subnet.name
    network_ip = "10.240.0.11"
    access_config {
      nat_ip = google_compute_address.vm_static_ip_worker1.address
    }
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220419"
      size = 50
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  
  metadata = {
   ssh-keys = "kishore:${file("~/.ssh/id_rsa.pub")}"
 } 

# We connect to our instance via Terraform and remotely executes our script using SSH
  provisioner "file" {
    source      = "/Users/kishore/Desktop/Tools/SYLER_GITHUB/K8SeasywayGCP/scripts/latest/k8sworker_bootstrap.sh"
    destination = "/tmp/k8sworker_bootstrap.sh"
    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_worker1.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/k8sworker_bootstrap.sh",
      "sudo bash /tmp/k8sworker_bootstrap.sh",
    ]

    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_worker1.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }
}

# Instance creation K8S Worker2

resource "google_compute_instance" "worker2" {
  name         = "k8s-worker2"
  machine_type = "e2-medium"
  zone         = var.zone
  can_ip_forward       = true
  tags = ["k8s-infra"]
  

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.k8s-infra-subnet.name
    network_ip = "10.240.0.12"
    access_config {
      nat_ip = google_compute_address.vm_static_ip_worker2.address
    }
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220419"
      size = 50
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  
  metadata = {
   ssh-keys = "kishore:${file("~/.ssh/id_rsa.pub")}"
 } 

# We connect to our instance via Terraform and remotely executes our script using SSH
  provisioner "file" {
    source      = "/Users/kishore/Desktop/Tools/SYLER_GITHUB/K8SeasywayGCP/scripts/latest/k8sworker_bootstrap.sh"
    destination = "/tmp/k8sworker_bootstrap.sh"
    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_worker2.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/k8sworker_bootstrap.sh",
      "sudo bash /tmp/k8sworker_bootstrap.sh",
    ]
    connection {
      type        = "ssh"
      host        = google_compute_address.vm_static_ip_worker2.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }
}


