#main.tf

provider "google" {
  credentials = file("service-account.json")
  project = var.default_project #data.default-project.project_id
  region  = "us-central1"
  zone    = var.zone
}


resource "google_compute_network" "devoir1" {
  name = var.default_network
  project = var.default_project

}


resource "google_compute_subnetwork" "prod-dmz" {
  name = "prod-dmz"
  network = var.default_network #data.google_compute_network.default-network.name
  ip_cidr_range = "172.16.3.0/24"
  description = "sous-réseau pour canard"

}

resource "google_compute_subnetwork" "prod-interne" {
  name = "prod-interne"
  network = var.default_network
  ip_cidr_range = "10.0.3.0/24"
  description = "sous-réseau pour mouton"

}

resource "google_compute_subnetwork" "prod-traitement" {
  name = "prod-traitement"
  network = var.default_network
  ip_cidr_range = "10.0.2.0/24"
  description = "sous-réseau pour cheval"
  
}


resource "google_compute_instance" "canard" {
  name         = "canard"
  machine_type = "f1-micro"
  description = "Instance canard"
  tags = ["public-web"]
  boot_disk {
    initialize_params {
      image = var.Image_debian
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork = google_compute_subnetwork.prod-dmz.name
    network = var.default_network
    access_config {
    }
  }
}

resource "google_compute_instance" "mouton" {
  name         = "mouton"
  machine_type = "f1-micro"
  description = "Instance mouton"
  tags = ["interne", "prod-interne"]
  
  boot_disk {
    initialize_params {
      image = var.Image_fedora
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = var.default_network
    subnetwork = "prod-interne"
    access_config {
    }
  }
}
resource "google_compute_instance" "cheval" {
  name         = "cheval"
  machine_type = "f1-micro"
  description = "Instance cheval"
  tags = ["traitement","prod-traitement"]
  boot_disk {
    initialize_params {
      image = var.Image_fedora
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = var.default_network
    subnetwork = "prod-traitement"
    access_config {
    }
  }
}
resource "google_compute_instance" "fermier" {
  name         = "fermier"
  machine_type = "f1-micro"
  description = "Instance fermier"
  boot_disk {
    initialize_params {
      image = var.Image_ubuntu
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = var.default_network
    access_config {
    }
  }
}

resource "google_compute_firewall" "traitement" {
  name = "traitement"
  allow { 
    protocol = "TCP"
    ports = ["2846","5462"]
  }
  source_tags = ["prod-interne"]
  target_tags = ["traitement"]
  network = var.default_network
}

resource "google_compute_firewall" "traficssh" {
  name = "traficssh"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["interne"]
  network = var.default_network

}

resource "google_compute_firewall" "traficweb" {
  name = "traficweb"
  allow {
    ports = ["80","443"]
    protocol = "tcp"
  }
  network = var.default_network
  target_tags = ["public-web"]
}



