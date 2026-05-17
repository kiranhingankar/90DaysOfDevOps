# Day 40 – Your First GitHub Actions Workflow

## Introduction

Today I created and executed my first GitHub Actions workflow.  
This was my first practical step into CI/CD automation using GitHub Actions.

The workflow automatically runs whenever code is pushed to the repository.

---

# Objective

- Learn the basics of GitHub Actions
- Create a workflow pipeline
- Understand workflow structure
- Execute automation in the cloud
- Learn how CI/CD pipelines succeed and fail

---

# Repository Setup

## Step 1: Create Repository

Created a public GitHub repository named:

```bash
github-actions-practice
```

---

## Step 2: Clone Repository

```bash
git clone https://github.com/your-username/github-actions-practice.git
```

Move into the repository:

```bash
cd github-actions-practice
```

---

## Step 3: Create Workflow Directory

```bash
mkdir -p .github/workflows
```

---

# Repository Structure

```bash
github-actions-practice/
│
├── .github/
│   └── workflows/
│       └── hello.yml
│
└── day-40-first-workflow.md
```

---

# Workflow File

File Path:

```bash
.github/workflows/hello.yml
```

---

# Complete Workflow YAML

```yaml
name: First GitHub Actions Workflow

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Hello Message
        run: echo "Hello from GitHub Actions!"

      - name: Print Current Date and Time
        run: date

      - name: Print Branch Name
        run: echo "Branch Name: ${{ github.ref_name }}"

      - name: List Repository Files
        run: ls -la

      - name: Print Runner Operating System
        run: echo "Runner OS: $RUNNER_OS"
```

---

# Push Workflow to GitHub

## Add Files

```bash
git add .
```

---

## Commit Changes

```bash
git commit -m "Added first GitHub Actions workflow"
```

---

## Push to GitHub

```bash
git push origin main
```

---

# Verify Workflow Execution

1. Open GitHub Repository
2. Navigate to the **Actions** tab
3. Select the workflow run
4. Open the `greet` job
5. Inspect each step and logs

---

# Understanding Workflow Anatomy

## `name:`

Defines the workflow name displayed inside GitHub Actions.

Example:

```yaml
name: First GitHub Actions Workflow
```

---

## `on:`

Defines the event that triggers the workflow.

Example:

```yaml
on:
  push:
```

This workflow runs automatically whenever code is pushed.

---

## `jobs:`

A workflow contains one or more jobs.

Example:

```yaml
jobs:
```

Each job runs independently inside a virtual machine.

---

## `runs-on:`

Defines which operating system the workflow runner uses.

Example:

```yaml
runs-on: ubuntu-latest
```

GitHub provides runners for:
- Ubuntu
- Windows
- macOS

---

## `steps:`

Defines the sequence of tasks inside a job.

Example:

```yaml
steps:
```

Each step runs one after another.

---

## `uses:`

Used to call reusable GitHub Actions.

Example:

```yaml
uses: actions/checkout@v4
```

This action checks out repository code into the runner.

---

## `run:`

Executes shell commands inside the runner machine.

Example:

```yaml
run: echo "Hello from GitHub Actions!"
```

---

## Step `name:`

Provides a readable label for each step.

Example:

```yaml
- name: Print Hello Message
```

Makes logs easier to read in GitHub Actions.

---

# Additional Tasks Added

## Print Current Date and Time

```yaml
- name: Print Current Date and Time
  run: date
```

---

## Print Branch Name

```yaml
- name: Print Branch Name
  run: echo "Branch Name: ${{ github.ref_name }}"
```

---

## List Repository Files

```yaml
- name: List Repository Files
  run: ls -la
```

---

## Print Runner Operating System

```yaml
- name: Print Runner Operating System
  run: echo "Runner OS: $RUNNER_OS"
```

---

# Breaking the Workflow Intentionally

To understand pipeline failures, I intentionally added a failing step.

Example:

```yaml
- name: Fail the Workflow
  run: exit 1
```

---

# Observations from Failed Workflow

- Workflow status turned red
- Failed step was highlighted
- GitHub displayed error logs
- The exact failed command was shown
- Remaining steps were skipped after failure

---

# Fixing the Workflow

Removed the failing command:

```yaml
run: exit 1
```

Pushed the updated code again and the workflow passed successfully.

---

# What a Successful Pipeline Looks Like

- Green checkmark appears beside workflow
- All steps show success
- Logs display completed execution
- Workflow status becomes **Completed**

---

# What I Learned

- Basics of GitHub Actions
- CI/CD workflow structure
- How automation works on every push
- How to execute shell commands in workflows
- Understanding jobs and steps
- How GitHub-hosted runners work
- How to debug failed pipelines
- Importance of automation in DevOps

---

# Screenshot Section

## Successful Green Pipeline

> Add screenshot here after successful run

Example:

```md
![Green Pipeline Screenshot](./screenshots/green-run.png)
```

---

# Commands Used During Practice

## Clone Repository

```bash
git clone https://github.com/your-username/github-actions-practice.git
```

---

## Navigate to Repository

```bash
cd github-actions-practice
```

---

## Create Workflow Directory

```bash
mkdir -p .github/workflows
```

---

## Add Files

```bash
git add .
```

---

## Commit Changes

```bash
git commit -m "Added GitHub Actions workflow"
```

---

## Push Code

```bash
git push origin main
```

---

# Final Thoughts

Today I built and executed my first GitHub Actions pipeline.

This was my first real CI/CD workflow running in the cloud.  
Understanding workflow structure, jobs, runners, steps, and debugging failures gave me practical exposure to DevOps automation.

The green checkmark after a successful run was a great learning milestone.

---