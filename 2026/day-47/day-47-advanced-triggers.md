# Day 47 – Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines

## Overview

Today I explored advanced GitHub Actions triggers including:

- Pull Request lifecycle events
- PR validation workflows
- Scheduled cron workflows
- Path & branch filtering
- Chaining workflows using `workflow_run`
- External event triggers using `repository_dispatch`

---

# Repository Structure

```bash
.github/
└── workflows/
    ├── pr-lifecycle.yml
    ├── pr-checks.yml
    ├── scheduled-tasks.yml
    ├── smart-triggers.yml
    ├── docs-ignore.yml
    ├── tests.yml
    ├── deploy-after-tests.yml
    └── external-trigger.yml

2026/
└── day-47/
    └── day-47-advanced-triggers.md
```

---

# Task 1 – Pull Request Lifecycle Events

## File

```bash
.github/workflows/pr-lifecycle.yml
```

## Workflow YAML

```yaml
name: PR Lifecycle Events

on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
      - closed

jobs:
  pr-info:
    runs-on: ubuntu-latest

    steps:
      - name: Print PR Event Type
        run: echo "Event Type -> ${{ github.event.action }}"

      - name: Print PR Title
        run: echo "PR Title -> ${{ github.event.pull_request.title }}"

      - name: Print PR Author
        run: echo "PR Author -> ${{ github.event.pull_request.user.login }}"

      - name: Print Source and Target Branch
        run: |
          echo "Source Branch -> ${{ github.head_ref }}"
          echo "Target Branch -> ${{ github.base_ref }}"

      - name: Run Only If PR Is Merged
        if: github.event.pull_request.merged == true
        run: echo "PR was merged successfully!"
```

---

# PR Lifecycle Event Testing

## Step 1 – Create Feature Branch

```bash
git checkout -b feature/pr-lifecycle-test
```

## Step 2 – Push Changes

```bash
git add .
git commit -m "Added PR lifecycle workflow"
git push origin feature/pr-lifecycle-test
```

## Step 3 – Open Pull Request

Workflow Triggered:

```text
opened
```

---

## Step 4 – Push Another Commit

```bash
echo "test" >> test.txt
git add .
git commit -m "Updated PR"
git push
```

Workflow Triggered:

```text
synchronize
```

---

## Step 5 – Merge Pull Request

Workflow Triggered:

```text
closed
```

Merged-only step executed successfully.

---

# Where to Check Workflow Runs

Go to:

```text
Repository → Actions
```

You can inspect:

- Workflow runs
- Logs
- Job outputs
- Event types
- PR metadata

---

# Task 2 – PR Validation Workflow

## File

```bash
.github/workflows/pr-checks.yml
```

## Workflow YAML

```yaml
name: PR Validation Checks

on:
  pull_request:
    branches:
      - main

jobs:
  file-size-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Check File Sizes
        run: |
          echo "Checking file sizes..."

          large_files=$(find . -type f -size +1M)

          if [ -n "$large_files" ]; then
            echo "Large files found:"
            echo "$large_files"
            exit 1
          fi

          echo "All files are below 1MB"

  branch-name-check:
    runs-on: ubuntu-latest

    steps:
      - name: Validate Branch Name
        run: |
          echo "Branch Name -> ${{ github.head_ref }}"

          if [[ "${{ github.head_ref }}" =~ ^(feature|fix|docs)/.+$ ]]; then
            echo "Valid branch name"
          else
            echo "Invalid branch name"
            exit 1
          fi

  pr-body-check:
    runs-on: ubuntu-latest

    steps:
      - name: Check PR Description
        run: |
          BODY="${{ github.event.pull_request.body }}"

          if [ -z "$BODY" ]; then
            echo "WARNING: PR description is empty"
          else
            echo "PR description exists"
          fi
```

---

# Branch Validation Testing

## Invalid Branch Example

```bash
git checkout -b random-update
```

Result:

```text
Workflow Failed
```

---

## Valid Branch Example

```bash
git checkout -b feature/login-page
```

Result:

```text
Workflow Passed
```

---

# Task 3 – Scheduled Workflows (Cron)

## File

```bash
.github/workflows/scheduled-tasks.yml
```

## Workflow YAML

```yaml
name: Scheduled Tasks

on:
  schedule:
    - cron: '30 2 * * 1'
    - cron: '0 */6 * * *'

  workflow_dispatch:

jobs:
  scheduled-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Trigger Schedule
        run: echo "Triggered by -> ${{ github.event.schedule }}"

      - name: Health Check
        run: |
          STATUS=$(curl -o /dev/null -s -w "%{http_code}" https://github.com)

          echo "HTTP Status Code -> $STATUS"

          if [ "$STATUS" -eq 200 ]; then
            echo "Health check passed"
          else
            echo "Health check failed"
            exit 1
          fi
```

---

# Cron Expressions

## Every Weekday at 9 AM IST

IST = UTC +5:30

9:00 AM IST = 3:30 AM UTC

```cron
30 3 * * 1-5
```

---

## First Day of Every Month at Midnight

```cron
0 0 1 * *
```

---

# Why Scheduled Workflows May Be Delayed

GitHub scheduled workflows may be delayed or skipped because:

- Shared runners may be overloaded
- Inactive repositories may pause schedules
- Schedules only run on the default branch
- Timing is not guaranteed to be exact

---

# Manual Workflow Testing

Because `workflow_dispatch` is enabled, workflows can be run manually:

```text
Repository → Actions → Scheduled Tasks → Run Workflow
```

---

# Task 4 – Path & Branch Filters

---

# Workflow 1 – Run Only When src/ or app/ Changes

## File

```bash
.github/workflows/smart-triggers.yml
```

## Workflow YAML

```yaml
name: Smart Path Triggers

on:
  push:
    branches:
      - main
      - 'release/*'

    paths:
      - 'src/**'
      - 'app/**'

jobs:
  filtered-job:
    runs-on: ubuntu-latest

    steps:
      - name: Trigger Message
        run: echo "Code changes detected in src/ or app/"
```

---

# Workflow 2 – Ignore Documentation Changes

## File

```bash
.github/workflows/docs-ignore.yml
```

## Workflow YAML

```yaml
name: Ignore Docs Changes

on:
  push:
    branches:
      - main
      - 'release/*'

    paths-ignore:
      - '*.md'
      - 'docs/**'

jobs:
  ignore-docs-job:
    runs-on: ubuntu-latest

    steps:
      - name: Workflow Triggered
        run: echo "Non-doc files changed"
```

---

# Testing Path Filters

## This Should NOT Trigger Workflow

```bash
echo "docs update" >> README.md
git add .
git commit -m "Updated docs"
git push
```

---

## This SHOULD Trigger Workflow

```bash
mkdir -p src
echo "console.log('hello')" > src/app.js

git add .
git commit -m "Updated source code"
git push
```

---

# paths vs paths-ignore

## Use `paths`

When workflow should run ONLY for specific directories or files.

Example:

- Deploy backend only when backend code changes

---

## Use `paths-ignore`

When workflow should run for everything EXCEPT some files.

Example:

- Ignore README or documentation updates

---

# Task 5 – workflow_run (Workflow Chaining)

---

# Workflow 1 – Tests Workflow

## File

```bash
.github/workflows/tests.yml
```

## Workflow YAML

```yaml
name: Run Tests

on:
  push:

jobs:
  test-job:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run Tests
        run: |
          echo "Running tests..."
          echo "Tests passed!"
```

---

# Workflow 2 – Deploy After Tests

## File

```bash
.github/workflows/deploy-after-tests.yml
```

## Workflow YAML

```yaml
name: Deploy After Tests

on:
  workflow_run:
    workflows:
      - Run Tests
    types:
      - completed

jobs:
  deploy:
    runs-on: ubuntu-latest

    if: github.event.workflow_run.conclusion == 'success'

    steps:
      - name: Deployment Step
        run: echo "Tests passed. Deploying application..."

  failed-message:
    runs-on: ubuntu-latest

    if: github.event.workflow_run.conclusion != 'success'

    steps:
      - name: Failure Message
        run: echo "Tests failed. Deployment skipped."
```

---

# Workflow Chaining Verification

Push a commit:

```bash
git add .
git commit -m "Testing workflow chaining"
git push
```

Execution Order:

```text
Run Tests
   ↓
Deploy After Tests
```

---

# workflow_run vs workflow_call

## workflow_run

- Executes AFTER another workflow finishes
- Used for workflow chaining
- Useful for CI → CD pipelines

Example:

```text
Tests → Deployment
```

---

## workflow_call

- Reuses workflows as templates
- Avoids duplicate YAML code
- One workflow directly calls another

Example:

```text
Reusable CI pipeline across repositories
```

---

# Task 6 – repository_dispatch

## File

```bash
.github/workflows/external-trigger.yml
```

## Workflow YAML

```yaml
name: External Event Trigger

on:
  repository_dispatch:
    types:
      - deploy-request

jobs:
  external-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Payload
        run: |
          echo "Environment -> ${{ github.event.client_payload.environment }}"
```

---

# Trigger Using GitHub CLI

## Install GitHub CLI

### Windows

```bash
winget install GitHub.cli
```

---

## Verify Installation

```bash
gh --version
```

---

## Login

```bash
gh auth login
```

---

## Trigger External Workflow

```bash
gh api repos/<owner>/<repo>/dispatches \
  -f event_type=deploy-request \
  -f client_payload='{"environment":"production"}'
```

Example:

```bash
gh api repos/kiran/devops-lab/dispatches \
  -f event_type=deploy-request \
  -f client_payload='{"environment":"production"}'
```

---

# When External Systems Trigger Pipelines

Examples:

- Slack bot triggers deployment
- Monitoring tools trigger recovery pipelines
- Security tools trigger scans
- External approval systems trigger releases
- Jenkins triggers GitHub Actions deployments

---

# Screenshots to Add

Add screenshots of:

- PR lifecycle workflow runs
- PR validation checks
- Scheduled workflow execution
- workflow_run chaining
- repository_dispatch trigger
- Workflow logs inside Actions tab

---

# Git Commands

## Add Files

```bash
git add .
```

---

## Commit Changes

```bash
git commit -m "Completed Day 47 advanced GitHub Actions triggers"
```

---

## Push Changes

```bash
git push origin main
```

---

# Key Learnings

Today I learned:

- GitHub Actions supports many event triggers beyond push events
- Pull request lifecycle events are powerful for automation
- Scheduled workflows can automate maintenance tasks
- Path filters optimize workflow execution
- `workflow_run` enables workflow chaining
- `repository_dispatch` allows external systems to trigger pipelines
- Automated PR checks improve code quality and team workflows

---

# Conclusion

Day 47 focused on advanced GitHub Actions automation patterns used in real-world DevOps pipelines. These workflows improve CI/CD reliability, automate validations, and support event-driven deployments.