output "nginx_container_id" {
  value = docker_container.nginx.id
}

output "health_checker_container_id" {
  value = docker_container.health_checker.id
}

output "network_id" {
  value = docker_network.exam.id
}
