terraform {
  required_providers {
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.7.0"
    }
  }
}

provider "gitea" {
  base_url = var.gitea_url
  token    = var.gitea_token
}

resource "gitea_repository" "exam" {
  username = var.gitea_username
  name     = "terraform-docker-exam"
  private  = true
}

resource "gitea_repository_branch_protection" "main" {
  username    = var.gitea_username
  name        = gitea_repository.exam.name
  rule_name   = "main"
  enable_push = false
}
