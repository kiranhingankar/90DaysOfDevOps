# Day 48 — Enterprise GitHub Actions CI/CD Project

## Project Overview

This project demonstrates a complete enterprise-style CI/CD pipeline using GitHub Actions, Docker, reusable workflows, environment approvals, and automated health checks.

The application is a Dockerized Flask web application with a modern glossy DevOps dashboard UI.

---

# Repository Details

## Repository Name

```text
enterprise-github-actions
```

---

# Tech Stack

* GitHub Actions
* Python Flask
* Docker
* Docker Hub
* GitHub Environments
* YAML Workflows
* CI/CD Automation

---

# Project Structure

```text
enterprise-github-actions/
│
├── .github/
│   └── workflows/
│       ├── reusable-build-test.yml
│       ├── reusable-docker.yml
│       ├── pr-pipeline.yml
│       ├── main-pipeline.yml
│       └── health-check.yml
│
├── templates/
│   └── index.html
│
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
└── day-48-actions-project.md
```

---

# Application Details

The Flask application contains:

* Homepage route `/`
* Health endpoint `/health`
* Docker support
* Modern glossy UI dashboard

---

# Flask Application

## app.py

```python
from flask import Flask, render_template, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return render_template("index.html")

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

# Docker Configuration

## Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Requirements File

## requirements.txt

```text
flask
pytest
```

---

# Pipeline Architecture

```text
Pull Request Opened
        ↓
Build & Test Workflow
        ↓
PR Validation

------------------------------------------------

Merge to Main
        ↓
Build & Test Workflow
        ↓
Docker Build & Push
        ↓
Production Approval
        ↓
Deploy

------------------------------------------------

Every 12 Hours
        ↓
Health Check Workflow
        ↓
Pull Docker Image
        ↓
Run Container
        ↓
Validate /health Endpoint
```

---

# Workflow 1 — Reusable Build & Test Workflow

## File

```text
.github/workflows/reusable-build-test.yml
```

## Purpose

Reusable workflow responsible for:

* Checking out code
* Setting up Python
* Installing dependencies
* Running tests
* Returning workflow outputs

## Workflow YAML

```yaml
name: Reusable Build and Test

on:
  workflow_call:
    inputs:
      python_version:
        required: true
        type: string

      run_tests:
        required: false
        type: boolean
        default: true

    outputs:
      test_result:
        value: ${{ jobs.build.outputs.test_result }}

jobs:
  build:
    runs-on: ubuntu-latest

    outputs:
      test_result: ${{ steps.result.outputs.status }}

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install Dependencies
        run: |
          pip install -r requirements.txt

      - name: Run Tests
        if: ${{ inputs.run_tests }}
        run: |
          pytest

      - name: Set Output
        id: result
        run: |
          echo "status=passed" >> $GITHUB_OUTPUT
```

---

# Workflow 2 — Reusable Docker Workflow

## File

```text
.github/workflows/reusable-docker.yml
```

## Purpose

Reusable workflow responsible for:

* Docker login
* Docker image build
* Docker image push
* SHA-based image tagging
* latest image tagging
* Returning image URL

## Workflow YAML

```yaml
name: Reusable Docker Build

on:
  workflow_call:
    inputs:
      image_name:
        required: true
        type: string

      tag:
        required: true
        type: string

    secrets:
      docker_username:
        required: true

      docker_token:
        required: true

    outputs:
      image_url:
        value: ${{ jobs.docker.outputs.image_url }}

jobs:
  docker:
    runs-on: ubuntu-latest

    outputs:
      image_url: ${{ steps.image.outputs.url }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.docker_username }}
          password: ${{ secrets.docker_token }}

      - name: Build Docker Image
        run: |
          docker build \
            -t ${{ secrets.docker_username }}/${{ inputs.image_name }}:latest \
            -t ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }} .

      - name: Push Docker Images
        run: |
          docker push ${{ secrets.docker_username }}/${{ inputs.image_name }}:latest

          docker push ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}

      - name: Set Image Output
        id: image
        run: |
          echo "url=${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}" >> $GITHUB_OUTPUT
```

---

# Workflow 3 — PR Pipeline

## File

```text
.github/workflows/pr-pipeline.yml
```

## Purpose

This workflow:

* Runs only on pull requests
* Executes tests only
* Prevents Docker image push on PRs

## Workflow YAML

```yaml
name: PR Pipeline

on:
  pull_request:
    branches:
      - main

    types:
      - opened
      - synchronize

jobs:
  build-test:
    uses: ./.github/workflows/reusable-build-test.yml

    with:
      python_version: '3.12'
      run_tests: true

  pr-comment:
    needs: build-test

    runs-on: ubuntu-latest

    steps:
      - name: PR Summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
```

---

# Workflow 4 — Main Pipeline

## File

```text
.github/workflows/main-pipeline.yml
```

## Purpose

This workflow:

* Runs after merge to main
* Executes tests
* Builds Docker image
* Pushes image to Docker Hub
* Deploys application
* Uses environment approvals

## Workflow YAML

```yaml
name: Main Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-test:
    uses: ./.github/workflows/reusable-build-test.yml

    with:
      python_version: '3.12'
      run_tests: true

  docker-build:
    needs: build-test

    uses: ./.github/workflows/reusable-docker.yml

    with:
      image_name: enterprise-app
      tag: sha-${{ github.sha }}

    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  deploy:
    needs: docker-build

    runs-on: ubuntu-latest

    environment:
      name: production

    steps:
      - name: Deploy Application
        run: |
          echo "Deploying image:"
          echo "${{ needs.docker-build.outputs.image_url }}"
          echo "to production"
```

---

# Workflow 5 — Health Check Workflow

## File

```text
.github/workflows/health-check.yml
```

## Purpose

This workflow:

* Runs every 12 hours
* Pulls latest Docker image
* Runs container
* Validates health endpoint
* Generates workflow summary

## Workflow YAML

```yaml
name: Health Check

on:
  schedule:
    - cron: '0 */12 * * *'

  workflow_dispatch:

jobs:
  health-check:
    runs-on: ubuntu-latest

    steps:
      - name: Pull Docker Image
        run: |
          docker pull ${{ secrets.DOCKER_USERNAME }}/enterprise-app:latest

      - name: Run Container
        run: |
          docker run -d -p 5000:5000 --name enterprise-app \
          ${{ secrets.DOCKER_USERNAME }}/enterprise-app:latest

      - name: Wait for Application
        run: sleep 5

      - name: Health Check
        run: |
          curl http://localhost:5000/health

      - name: Create Summary
        run: |
          echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
          echo "- Image: enterprise-app:latest" >> $GITHUB_STEP_SUMMARY
          echo "- Status: PASSED" >> $GITHUB_STEP_SUMMARY
          echo "- Time: $(date)" >> $GITHUB_STEP_SUMMARY

      - name: Cleanup Container
        run: |
          docker stop enterprise-app
          docker rm enterprise-app
```

---

# GitHub Secrets Configuration

## Repository Secrets

Configured under:

```text
Repository Settings → Secrets and Variables → Actions
```

## Secrets Used

| Secret Name     | Purpose                 |
| --------------- | ----------------------- |
| DOCKER_USERNAME | Docker Hub username     |
| DOCKER_TOKEN    | Docker Hub access token |

---

# GitHub Environment Configuration

## Environment Name

```text
production
```

## Features Used

* Required reviewers
* Deployment approvals
* Protected deployment flow

---

# Docker Commands Used Locally

## Build Docker Image

```bash
docker build -t enterprise-app .
```

## Run Docker Container

```bash
docker run -d -p 5000:5000 --name enterprise-app enterprise-app
```

## Verify Running Containers

```bash
docker ps
```

## View Logs

```bash
docker logs enterprise-app
```

## Stop Container

```bash
docker stop enterprise-app
```

## Remove Container

```bash
docker rm enterprise-app
```

---

# Health Endpoint

## URL

```text
http://localhost:5000/health
```

## Response

```json
{"status":"healthy"}
```

---

# Screenshots to Add

## Screenshot 1

PR Pipeline Running:

```text
Pull Request → Build & Test → Success
```

---

## Screenshot 2

Main Pipeline Running:

```text
Build → Docker Push → Deploy → Success
```

---

## Screenshot 3

Production Approval:

```text
Review deployments → Approve and deploy
```

---

## Screenshot 4

Health Check Workflow Summary

---

# Docker Hub Repository

## Docker Image

```text
https://hub.docker.com/r/YOUR_DOCKER_USERNAME/enterprise-app
```

---

# Key Learnings

During this project I learned:

* Reusable GitHub Actions workflows
* Workflow dependencies
* Docker automation with CI/CD
* Secrets management
* Environment approvals
* Scheduled GitHub workflows
* Docker image tagging strategies
* Health monitoring automation
* Enterprise deployment architecture
* Flask containerization
* CI/CD orchestration

---

# Challenges Faced

## 1. GitHub Actions Syntax Errors

Resolved workflow YAML indentation and syntax issues.

## 2. Docker Image Tagging

Implemented support for:

* latest
* SHA-based tags

## 3. Flask Template Errors

Resolved:

```text
TemplateNotFound: index.html
```

by using:

```text
templates/index.html
```

## 4. Python Indentation Errors

Fixed Flask application indentation issues causing container failures.

## 5. Health Check Failures

Updated Docker tagging strategy to ensure latest image availability.

---

# Future Improvements

Future enhancements planned:

* Slack notifications
* Kubernetes deployment
* AWS EC2 deployment
* Trivy security scanning
* Rollback support
* Multi-environment deployment
* Blue-Green deployments
* Terraform infrastructure automation
* Monitoring with Prometheus & Grafana
* Helm chart deployments

---

# Conclusion

This project demonstrates a complete enterprise-style CI/CD implementation using GitHub Actions.

The workflow automates:

* Testing
* Docker image creation
* Image publishing
* Deployment approvals
* Health monitoring

This project provided hands-on experience with production-style DevOps practices and CI/CD pipeline orchestration.

---
