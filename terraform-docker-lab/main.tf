variable "external_port" {
  description = "The port exposed to the host machine"
  type        = number
  default     = 8888
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 1. This acts exactly like 'docker pull nginx:latest'
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# 2. This acts exactly like 'docker run --name dazit-web-server -p 8080:80 -d'
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "dazit-web-server"

  ports {
    internal = 80
    external = var.external_port  #Variable referenced from the top
  }
}