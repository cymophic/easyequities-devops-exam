variable "nginx_host_port" {
  description = "Host port to map to Nginx container port 80"
  type        = number
  default     = 8080

  validation {
    condition     = var.nginx_host_port >= 1024 && var.nginx_host_port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}
