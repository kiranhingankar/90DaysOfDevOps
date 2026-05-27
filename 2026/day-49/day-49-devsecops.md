# Day 49 – DevSecOps: Adding Security to My CI/CD Pipeline

---

## 🔐 Overview

Today I upgraded my GitHub Actions CI/CD pipeline into a **DevSecOps pipeline** by adding automated security checks before deployment.

Earlier CI/CD pipelines only focus on:
Build → Test → Deploy

Now my pipeline follows:
Build → Test → Security Scan → Deploy

This means security is now part of the delivery process, not an afterthought.

---

## ⚡ What I Built Today

In my `enterprise-github-actions` project, I implemented a full DevSecOps pipeline with:

- Dependency vulnerability scanning (PR stage)
- Docker image vulnerability scanning (build stage)
- Secret scanning & push protection
- Secure workflow permissions
- Automated failure on HIGH/CRITICAL issues

---

# 🧪 1. Dependency Vulnerability Scanning (PR Stage)

## Tool Used
actions/dependency-review-action@v4

## What it does
- Scans dependencies added in Pull Requests
- Checks against CVE (Common Vulnerabilities and Exposures) database
- Blocks insecure packages before merging

## Why it matters
✔ Prevents vulnerable dependencies from entering production  
✔ Secures supply chain at PR level  
✔ Ensures safer software updates  

---

# 🐳 2. Docker Image Vulnerability Scanning (Build Stage)

## Tool Used
aquasecurity/trivy-action@master

## What it does
- Scans Docker images after build
- Detects OS-level vulnerabilities (Debian packages)
- Detects Python package vulnerabilities
- Detects HIGH and CRITICAL CVEs
- Fails pipeline if risks are found

## Example vulnerabilities found
- libncurses
- libtinfo
- wheel
- jaraco.context

## Why it matters
✔ Prevents insecure containers from production  
✔ Detects base image risks  
✔ Secures runtime environment  

---

# 🔐 3. GitHub Secret Protection

## Enabled Features
- Secret Scanning
- Push Protection

## What it does
- Detects sensitive data in repository
- Prevents leaks of:
  - API keys
  - Passwords
  - Access tokens

## Behavior
- Secret scanning → detects after push
- Push protection → blocks before push

## Why it matters
✔ Prevents credential leaks  
✔ Protects cloud accounts  
✔ Adds automatic security layer  

---

# 🛡️ 4. Secure Workflow Permissions

## Configuration Used

```yaml
permissions:
  contents: read