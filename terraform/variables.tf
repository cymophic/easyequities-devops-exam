variable "gitea_url" {
  description = "Gitea server URL"
  type        = string
}

variable "gitea_token" {
  description = "Gitea access token"
  type        = string
  sensitive   = true
}

variable "gitea_username" {
  description = "Gitea username"
  type        = string
}
