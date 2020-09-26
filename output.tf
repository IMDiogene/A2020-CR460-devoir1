output "adresse_ip_serveur" {
    value = google_compute_instance.canard.network_interface.0.access_config.0.nat_ip
}