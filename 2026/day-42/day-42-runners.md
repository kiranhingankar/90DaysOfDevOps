# Day 42 – Runners: GitHub-Hosted & Self-Hosted

# Objective

Learn how GitHub Actions runners work by:
- Using GitHub-hosted runners
- Exploring pre-installed tools
- Setting up a self-hosted runner
- Running workflows on your own machine
- Using labels for runner targeting

---

# What is a Runner?

A runner is a machine that executes GitHub Actions workflows.

There are two types of runners:

1. GitHub-hosted runners
2. Self-hosted runners

---

# Task 1 – GitHub-Hosted Runners

## Workflow File

Created:

```text
.github/workflows/github-hosted.yml
```

## Workflow Configuration

```yaml
name: GitHub Hosted Runners

on:
  workflow_dispatch:

jobs:

  ubuntu-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Ubuntu Details
        run: |
          echo "OS: Ubuntu"
          hostname
          whoami

  windows-job:
    runs-on: windows-latest

    steps:
      - name: Print Windows Details
        run: |
          echo "OS: Windows"
          hostname
          whoami

  macos-job:
    runs-on: macos-latest

    steps:
      - name: Print macOS Details
        run: |
          echo "OS: macOS"
          hostname
          whoami

  tools-check:
    runs-on: ubuntu-latest

    steps:
      - name: Check Installed Tools
        run: |
          echo "Docker Version:"
          docker --version

          echo "Python Version:"
          python3 --version

          echo "Node Version:"
          node --version

          echo "Git Version:"
          git --version
```

---

# What is a GitHub-hosted Runner?

A GitHub-hosted runner is a temporary virtual machine provided and managed by GitHub to execute GitHub Actions workflows.

## Who Manages It?

GitHub manages:
- Infrastructure
- Updates
- Security patches
- Installed software
- Scaling

---

# Task 2 – Explore Pre-installed Software

## Tools Checked

The following tools were already installed on `ubuntu-latest`:

- Docker
- Python
- Node.js
- Git

## Why Pre-installed Tools Matter

Pre-installed tools make workflows faster because there is no need to manually install common software during every workflow run.

Benefits:
- Faster execution
- Reduced setup time
- Consistent environments
- Easier CI/CD setup

---

# GitHub Runner Images Documentation

GitHub provides official runner images with pre-installed software.

Useful Links:
- https://github.com/actions/runner-images
- https://docs.github.com/en/actions

---

# Task 3 – Set Up Self-Hosted Runner

## Steps Performed

### 1. Open Runner Settings

Navigated to:

```text
Repository → Settings → Actions → Runners
```

Clicked:
```text
New self-hosted runner
```

Selected:
- Linux
- x64

---

### 2. Created Runner Directory

```bash
mkdir actions-runner && cd actions-runner
```

---

### 3. Downloaded Runner

```bash
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases
```

---

### 4. Extracted Runner

```bash
tar xzf ./actions-runner-linux-x64.tar.gz
```

---

### 5. Configured Runner

```bash
./config.sh --url https://github.com/YOUR_USERNAME/YOUR_REPO --token YOUR_TOKEN
```

---

### 6. Started Runner

```bash
./run.sh
```

Runner status displayed:

```text
Listening for Jobs
```

---

# Verification

Verified in GitHub:

```text
Repository → Settings → Actions → Runners
```

Runner appeared with:
- Green status indicator
- Idle state

---

# Screenshot – Self-hosted Runner Idle

> Add screenshot here

---

# Task 4 – Use Self-Hosted Runner

## Workflow File

Created:

```text
.github/workflows/self-hosted.yml
```

## Workflow Configuration

```yaml
name: Self Hosted Runner

on:
  workflow_dispatch:

jobs:
  self-hosted-job:
    runs-on: self-hosted

    steps:
      - name: Print Machine Details
        run: |
          echo "Hostname:"
          hostname

          echo "Current Directory:"
          pwd

          echo "Current User:"
          whoami

      - name: Create File
        run: |
          echo "Hello from self-hosted runner" > runner-test.txt
          ls -la
```

---

# Workflow Verification

Verified:
- Workflow executed on EC2/self-hosted machine
- Hostname matched VM hostname
- File was created successfully

## File Verification

```bash
find ~ -name runner-test.txt
```

Output:

```text
/home/ubuntu/actions-runner/_work/REPO_NAME/REPO_NAME/runner-test.txt
```

---

# Screenshot – Job Running on Self-hosted Runner

> Add screenshot here

---

# Task 5 – Labels

## Added Label

Added custom label:

```text
my-linux-runner
```

---

## Updated Workflow

```yaml
runs-on: [self-hosted, my-linux-runner]
```

---

# Why Labels Are Useful

Labels help target specific runners when multiple self-hosted runners are available.

Examples:
- GPU runner
- High-memory runner
- Docker-enabled runner
- Linux-only runner

Labels ensure jobs run on the correct machine.

---

# Task 6 – GitHub-hosted vs Self-hosted

| Feature | GitHub-hosted | Self-hosted |
|---|---|---|
| Who manages it? | GitHub | User |
| Cost | Free tier + paid minutes | Infrastructure cost |
| Pre-installed tools | Many tools included | User installs manually |
| Good for | Standard CI/CD workloads | Custom environments |
| Security concern | Shared cloud infrastructure | User responsible for security |

---

# Important Commands

## Start Runner

```bash
./run.sh
```

---

## Install as Service

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

---

## Stop Service

```bash
sudo ./svc.sh stop
```

---

## Restart Service

```bash
sudo ./svc.sh restart
```

---

# Key Learnings

- GitHub-hosted runners are quick and easy to use
- Self-hosted runners provide full control
- Workflows can run on personal infrastructure
- Labels help manage multiple runners
- Pre-installed tools improve CI/CD speed

---

# Repository Structure

```text
2026/
└── day-42/
    └── day-42-runners.md

.github/
└── workflows/
    ├── github-hosted.yml
    └── self-hosted.yml
```

---

# Final Submission

Commands used:

```bash
git add .
git commit -m "Completed Day 42 runners lab"
git push origin main
```

---

# Conclusion

Successfully:
- Used GitHub-hosted runners
- Explored runner environments
- Configured a self-hosted runner
- Ran workflows on personal infrastructure
- Used labels for runner targeting

This lab demonstrated how GitHub Actions workflows can run on both GitHub-managed infrastructure and custom machines.