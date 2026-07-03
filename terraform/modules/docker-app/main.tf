terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.5.0"
    }
  }
}

# Network
resource "docker_network" "exam" {
  name = "exam-network"

  labels {
    label = "project"
    value = "devops-exam"
  }
  labels {
    label = "environment"
    value = "development"
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}

# Volume
resource "docker_volume" "exam" {
  name = "exam-web-data"

  labels {
    label = "project"
    value = "devops-exam"
  }
  labels {
    label = "environment"
    value = "development"
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}

# Nginx Image
resource "docker_image" "nginx" {
  name         = "nginx:1.27.4"
  keep_locally = true
}

# Nginx Container
resource "docker_container" "nginx" {
  name  = "exam-web-server"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_host_port
  }

  volumes {
    volume_name    = docker_volume.exam.name
    container_path = "/var/cache/nginx"
  }

  networks_advanced {
    name = docker_network.exam.name
  }

  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:80"]
    interval     = "30s"
    timeout      = "5s"
    retries      = 3
    start_period = "5s"
  }

  labels {
    label = "project"
    value = "devops-exam"
  }
  labels {
    label = "environment"
    value = "development"
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}

# Curl Image
resource "docker_image" "curl" {
  name         = "curlimages/curl:8.17.0"
  keep_locally = true
}

# Health Checker Container
resource "docker_container" "health_checker" {
  name  = "exam-health-checker"
  image = docker_image.curl.image_id

  command = [
    "sh", "-c",
    "while true; do curl -sf http://exam-web-server:80 || echo 'Health check failed'; sleep 30; done"
  ]

  networks_advanced {
    name = docker_network.exam.name
  }

  depends_on = [docker_container.nginx]

  labels {
    label = "project"
    value = "devops-exam"
  }
  labels {
    label = "environment"
    value = "development"
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}
