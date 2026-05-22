# Day 45 – Docker Build & Push in GitHub Actions

## Objective
Build a complete CI/CD pipeline where every push to the `main` branch automatically:

- Builds a Docker image
- Tags the image
- Pushes it to Docker Hub
- Displays workflow status in GitHub README

---

# Project Structure

```bash
github-actions-practice/
│
├── .github/
│   └── workflows/
│       └── docker-publish.yml
│
├── Dockerfile
├── app.py
├── requirements.txt
├── README.md
└── 2026/
    └── day-45/
        └── day-45-docker-cicd.md
```

---

# Task 1 – Prepare the Repository

## Prerequisites

### Docker Hub Secrets Added in GitHub

Navigate to:

```bash
GitHub Repo → Settings → Secrets and variables → Actions
```

Add the following secrets:

| Secret Name | Description |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token |

---

# Sample Dockerfile

```Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Task 2 – Build Docker Image in GitHub Actions

## Workflow File

Create:

```bash
.github/workflows/docker-publish.yml
```

---

# Complete GitHub Actions Workflow

```yaml
name: Docker Publish

on:
  push:
    branches:
      - main
      - feature/**

jobs:
  docker:
    runs-on: ubuntu-latest

    permissions:
      contents: read

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set Short SHA
        id: vars
        run: echo "sha_short=$(echo $GITHUB_SHA | cut -c1-7)" >> $GITHUB_OUTPUT

      - name: Log in to Docker Hub
        if: github.ref == 'refs/heads/main'
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build Docker Image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/github-actions-practice:latest
            ${{ secrets.DOCKER_USERNAME }}/github-actions-practice:sha-${{ steps.vars.outputs.sha_short }}

      - name: Push Docker Image
        if: github.ref == 'refs/heads/main'
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/github-actions-practice:latest
            ${{ secrets.DOCKER_USERNAME }}/github-actions-practice:sha-${{ steps.vars.outputs.sha_short }}
```

---

# Task 3 – Push Docker Image to Docker Hub

## What Happens?

When code is pushed to the `main` branch:

1. GitHub Actions starts automatically
2. Docker image is built
3. Image gets tagged:
   - `latest`
   - `sha-<commit>`
4. Image is pushed to Docker Hub

---

# Example Image Tags

```bash
kiranhingankar/github-actions-practice:latest
kiranhingankar/github-actions-practice:sha-a1b2c3d
```

---

# Verify Docker Images

Open Docker Hub and verify both tags exist.

## Docker Hub Repository

```text
https://hub.docker.com/r/<your-dockerhub-username>/github-actions-practice
```

Example:

```text
https://hub.docker.com/r/kiranhingankar/github-actions-practice
```

---

# Task 4 – Push Only on Main Branch

## Condition Used

```yaml
if: github.ref == 'refs/heads/main'
```

This ensures:

| Branch | Build | Push |
|---|---|---|
| `main` | ✅ | ✅ |
| `feature/*` | ✅ | ❌ |
| Pull Request | ✅ | ❌ |

---

# Feature Branch Test

## Tested Scenario

```bash
git checkout -b feature/test-pipeline
git push origin feature/test-pipeline
```

### Result

- Workflow triggered
- Docker image built successfully
- Image was NOT pushed to Docker Hub

This confirms branch protection logic works correctly.

---

# Task 5 – Add GitHub Actions Status Badge

## Badge Markdown

Add this to `README.md`:

```md
![Docker Publish](https://github.com/<username>/<repo>/actions/workflows/docker-publish.yml/badge.svg)
```

Example:

```md
![Docker Publish](https://github.com/kiranhingankar/github-actions-practice/actions/workflows/docker-publish.yml/badge.svg)
```

---

# README Output

The badge becomes green when the workflow passes successfully.

Example:

```text
Docker Publish — passing
```

---

# Task 6 – Pull and Run the Docker Image

## Pull the Image

```bash
docker pull kiranhingankar/github-actions-practice:latest
```

---

## Run the Container

```bash
docker run -d -p 5000:5000 kiranhingankar/github-actions-practice:latest
```

---

## Verify Running Container

```bash
docker ps
```

Open in browser:

```text
http://localhost:5000
```

Application runs successfully from the Docker Hub image.

---

# Full CI/CD Journey

## End-to-End Flow

### Step 1 – Developer Pushes Code

```bash
git add .
git commit -m "Added Docker CI/CD pipeline"
git push origin main
```

---

### Step 2 – GitHub Actions Triggered

GitHub detects a push event on the `main` branch and starts the workflow automatically.

---

### Step 3 – Source Code Checkout

The workflow checks out the repository source code using:

```yaml
uses: actions/checkout@v4
```

---

### Step 4 – Docker Image Build

GitHub Actions builds the Docker image using the Dockerfile.

---

### Step 5 – Docker Hub Authentication

GitHub Actions securely logs into Docker Hub using encrypted GitHub Secrets.

---

### Step 6 – Docker Image Tagging

The image receives two tags:

```bash
latest
sha-<short-commit-hash>
```

This helps with:

- Version tracking
- Rollbacks
- Deployment consistency

---

### Step 7 – Push to Docker Hub

The Docker image is uploaded to Docker Hub automatically.

---

### Step 8 – Deployment or Pull

Servers, cloud VMs, or Kubernetes clusters can now pull the latest image directly from Docker Hub.

---

### Step 9 – Run Container

The image is executed as a running container using:

```bash
docker run
```

---

# Pipeline Benefits

| Benefit | Description |
|---|---|
| Automation | No manual Docker builds |
| Consistency | Same image everywhere |
| Faster Releases | Immediate delivery |
| Versioning | SHA-based image tags |
| Scalability | Ready for Kubernetes/Cloud |
| Reliability | CI validation before deployment |

---

# Screenshot Section

## Add Screenshots Here

### 1. Successful GitHub Actions Workflow

```text
Insert screenshot here
```

---

### 2. Docker Hub Repository

```text
Insert screenshot here
```

---

### 3. Running Docker Container

```text
Insert screenshot here
```

---

# Commands Summary

## Build Locally

```bash
docker build -t github-actions-practice .
```

---

## Run Locally

```bash
docker run -p 5000:5000 github-actions-practice
```

---

## Pull From Docker Hub

```bash
docker pull kiranhingankar/github-actions-practice:latest
```

---

## Run Pulled Image

```bash
docker run -d -p 5000:5000 kiranhingankar/github-actions-practice:latest
```

---

# Key Learnings

- Learned GitHub Actions workflow automation
- Built Docker images inside CI pipelines
- Used Docker Hub authentication securely
- Implemented conditional deployments
- Added GitHub Actions status badges
- Practiced real-world CI/CD concepts
- Understood complete Docker delivery lifecycle

---

# Final Outcome

✅ Automated Docker Build Pipeline  
✅ Automated Docker Hub Push  
✅ Multi-tag Docker Images  
✅ Branch-based Push Protection  
✅ GitHub Actions Status Badge  
✅ Docker Image Running Successfully  

---
