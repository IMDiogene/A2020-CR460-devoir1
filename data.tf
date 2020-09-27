



data "google_project" "default-project" {
    project_id = var.default_project
}

data "google_compute_network" "default-network" {
  name = var.default_network
  #description = "réseau principal"
  project = data.google_project.default-project.project_id
  
}