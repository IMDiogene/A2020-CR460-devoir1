#main.tf

provider "google" {
  credentials = file("service-account.json")
  project = "excellent-bolt-288300"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "devoir1" {
  name = "devoir1"
  description = "réseau principal"
  
}

resource "google_compute_subnetwork" "prod-dmz" {
  name = "prod-dmz"
  network = "devoir1"
  ip_cidr_range = "172.16.3.0/24"
  description = "sous-réseau pour canard"

}

resource "google_compute_subnetwork" "prod-interne" {
  name = "prod-interne"
  network = "devoir1"
  ip_cidr_range = "10.0.3.0/24"
  description = "sous-réseau pour mouton"

}

resource "google_compute_subnetwork" "prod-traitement" {
  name = "prod-traitement"
  network = "devoir1"
  ip_cidr_range = "10.0.2.0/24"
  description = "sous-réseau pour cheval"
  tags = "traitement"
  
}


resource "google_compute_instance" "vm_instance" {
  name         = "canard"
  machine_type = "f1-micro"
  description = "Instance canard"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "devoir1"
    access_config {
    }
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "mouton"
  machine_type = "f1-micro"
  description = "Instance mouton"
  tags = ["interne"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "devoir1"
    subnetwork = "prod-interne"
    access_config {
    }
  }
}
resource "google_compute_instance" "vm_instance" {
  name         = "cheval"
  machine_type = "f1-micro"
  description = "Instance cheval"
  tags = ["traitement","prod-traitement"]
  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "devoir1"
    subnetwork = "prod-traitement"
    access_config {
    }
  }
}
resource "google_compute_instance" "vm_instance" {
  name         = "fermier"
  machine_type = "f1-micro"
  description = "Instance fermier"
  boot_disk {
    initialize_params {
      image = "Ubuntu 20.04"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "devoir1"
    access_config {
    }
  }
}

resource "google_compute_firewall" "traitement" {
  allow { 
    ports = ["2846","5462"]
  }
  source_tags = ["traitement"]
}

resource "google_compute_firewall" "ssh" {
  allow {
    protocol = "ssh"
  }
  source_tags = ["public-web"]
  target_tags = ["interne"]
  
}

resource "google_compute_firewall" "trafic-web" {
  allow {
    ports = ["80","443"]
  }
  
}


