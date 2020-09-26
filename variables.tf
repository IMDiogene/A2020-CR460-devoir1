variable "default_project" {
    type = string
    default = "excellent-bolt-288300"
}

variable "zone" {
    type = string
    default = "us-central1-c"
}

variable "default_network" {
    type = string
    description = "(optional) describe your variable"
    default = "devoir1"
}

variable "Image_fedora" {
    type = string
    default= "fedora-coreos-cloud/fedora-coreos-stable"
}

variable "Image_debian" {
    type = string
    default = "debian-cloud/debian-9"
}

variable "Image_ubuntu" {
    type = string
    default = "ubuntu-os-cloud/ubuntu-2004-lts"
}

# variable "google_project" {
#     type = string
#     default = ""
# }