# DevOps Exam Submission

My submission for a DevOps exam about self-hosting a Gitea Git server and managing infrastructure as code.

---

## 📋 Context

| | |
|---|---|
| **Company** | EasyEquities Philippines |
| **Date Received** | July 2, 2026 |
| **Submission Deadline** | July 5, 2026 |
| **Submit To** | devops-exam@easyequities.com.ph |

---

## 📚 Table of Contents

1. 🎯 [Objective](#-objective)
2. 📁 [Project Structure](#-project-structure)
3. ⚙️ [Prerequisites](#-prerequisites)
4. 🚀 [Getting Started](#-getting-started)
5. 🔢 [Parts Overview](#-parts-overview)
6. 📤 [Submission](#-submission)
7. 📝 [Notes](#-notes)

---

## 🎯 Objective

Self-host a Gitea Git server using Docker Compose, manage infrastructure and Docker resources using Terraform with reusable modules, and follow a structured Git workflow using Conventional Commits.

---

## 📁 Project Structure

```
easyequities-devops-exam/
├── terraform/
│   ├── modules/
│   │   └── docker-app/               # Reusable Docker module
│   │       ├── main.tf               # Module resource definitions
│   │       ├── variables.tf          # Module input variables
│   │       └── outputs.tf            # Module output values
│   ├── main.tf                       # Root Terraform config
│   ├── variables.tf                  # Root variable declarations
│   ├── outputs.tf                    # Root output definitions
│   ├── terraform.tfvars              # Variable values (gitignored)
│   └── terraform.tfvars.example      # Variable template
├── outputs/                          # Captured submission outputs
├── .gitignore                        # Excludes Terraform state, .tfvars, etc.
└── docker-compose.yml                # Docker Compose setup
```

---

## ⚙️ Prerequisites

- **Docker Desktop** — installed and running
- **Terraform** v1.0+
- **Git**

---

## 🚀 Getting Started

### 1. Start Gitea

```bash
docker compose up -d
```

Access Gitea at `http://localhost:3000` and complete the initial setup. Register a new user to create your credentials.

### 2. Generate a Gitea Access Token

Go to **Settings → Applications → Manage Access Tokens** and generate a token with the following scopes:

- `write:repository`
- `write:user`
- `read:organization`
- `write:issue`

Save the token — you'll need it for Terraform.

### 3. Initialize and Apply Terraform

```bash
cd terraform/
terraform init
terraform apply
```

This will:
- Create a private Gitea repository named `terraform-docker-exam`
- Configure branch protection on `main`
- Create Docker network `exam-network` and volume `exam-web-data`
- Start Nginx container `exam-web-server` on port `8081`
- Start health checker container `exam-health-checker`

### 4. Verify

```bash
# Nginx should be accessible
curl http://localhost:8081

# Health checker should be running
docker logs exam-health-checker
```

---

## 🔢 Parts Overview

| Part | Description |
|---|---|
| **Part 1** | Deploy Gitea using `docker-compose.yml` |
| **Part 2** | Terraform — create private Gitea repo + branch protection |
| **Part 3** | Terraform — Docker provider via reusable module (`modules/docker-app/`) |
| **Part 4** | Git workflow — conventional commits, `update-port` branch, push to Gitea |

---

## 📤 Submission

### Capture Outputs

```bash
mkdir -p outputs

cd terraform/
terraform show > ../outputs/terraform-state.txt
terraform output > ../outputs/terraform-output.txt
terraform validate -json > ../outputs/terraform-validate.json
terraform plan -no-color > ../outputs/terraform-plan.txt

docker ps > ../outputs/docker-ps.txt
docker network inspect exam-network > ../outputs/docker-network.txt
docker logs exam-health-checker > ../outputs/health-checker-logs.txt 2>&1
docker inspect --format '{{.State.Health.Status}}' exam-web-server > ../outputs/nginx-health.txt

curl -s http://localhost:8081 > ../outputs/nginx-welcome.html
```

### Capture Gitea API Outputs

Replace `USER` and `TOKEN` with your Gitea credentials:

```bash
cd ..
REPO="http://localhost:3000/api/v1/repos/USER/terraform-docker-exam"
curl -s -H "Authorization: token TOKEN" $REPO > outputs/gitea-repo.json
curl -s -H "Authorization: token TOKEN" $REPO/branch_protections > outputs/gitea-branch-protection.json
```

---

## 📝 Notes

### Why `terraform/` folder instead of root
Keeping Terraform files in a dedicated `terraform/` folder is a common convention for projects that mix application and infrastructure code. It keeps the project root clean and makes it clear where infrastructure code lives.

### Why `terraform.tfvars` is gitignored but `.example` is committed
`terraform.tfvars` contains sensitive values like tokens and credentials — it should never be committed. The `.example` file serves as a reference for what values are needed.
