# Day 41 – Triggers & Matrix Builds

## Overview
Today I learned how to use different GitHub Actions triggers and how to run workflows across multiple environments using matrix builds.

Topics covered:
- Pull Request Triggers
- Scheduled Workflows
- Manual Workflow Dispatch
- Matrix Builds
- Exclude Rules
- Fail-Fast Behavior

---

# Task 1 – Pull Request Trigger

## File Created
```bash
.github/workflows/pr-check.yml
```

## Workflow YAML

```yaml
# Workflow name shown in GitHub Actions tab
name: PR Check Workflow

# Trigger workflow when PR is opened or updated
on:
  pull_request:
    branches:
      - main

    # PR events
    types:
      - opened
      - synchronize

jobs:
  # Job ID
  pr-check:

    # Runner environment
    runs-on: ubuntu-latest

    steps:

      # Print source branch name
      - name: Print PR Branch
        run: echo "PR check running for branch: ${{ github.head_ref }}"
```

---

## What I Learned
- `pull_request` triggers workflows for PR events
- `opened` runs when PR is created
- `synchronize` runs when new commits are pushed
- `${{ github.head_ref }}` prints the PR source branch

---

## Verification
✅ Workflow appeared on the Pull Request page  
✅ Workflow ran automatically after PR update

---

# Task 2 – Scheduled Trigger

## File Created
```bash
.github/workflows/schedule.yml
```

## Workflow YAML

```yaml
# Workflow name
name: Scheduled Workflow

# Scheduled trigger
on:
  schedule:

    # Run every day at midnight UTC
    - cron: '0 0 * * *'

jobs:
  scheduled-job:

    # Runner
    runs-on: ubuntu-latest

    steps:

      # Print message
      - name: Print Message
        run: echo "This workflow runs every day at midnight UTC"
```

---

## Cron Expression Learned

### Every day at midnight UTC
```cron
0 0 * * *
```

### Every Monday at 9 AM UTC
```cron
0 9 * * 1
```

---

## What I Learned
- `schedule` is used for automated timed workflows
- GitHub Actions uses cron syntax
- Scheduled workflows usually run from the default branch

---

# Task 3 – Manual Trigger

## File Created
```bash
.github/workflows/manual.yml
```

## Workflow YAML

```yaml
# Workflow name
name: Manual Workflow

# Manual trigger
on:
  workflow_dispatch:

    # User inputs
    inputs:

      # Environment input
      environment:
        description: "Enter environment name"
        required: true
        default: "staging"

jobs:
  manual-job:

    # Runner
    runs-on: ubuntu-latest

    steps:

      # Print selected environment
      - name: Print Environment
        run: echo "Selected environment: ${{ github.event.inputs.environment }}"
```

---

## What I Learned
- `workflow_dispatch` allows manual workflow execution
- Inputs can be passed during workflow execution
- Inputs are accessible using:
  
```yaml
${{ github.event.inputs.environment }}
```

---

## Verification
✅ Workflow successfully triggered manually  
✅ Input value printed in logs

---

# Task 4 – Matrix Builds

## File Created
```bash
.github/workflows/matrix.yml
```

## Workflow YAML

```yaml
# Workflow name shown in GitHub Actions tab
name: Matrix Build

# Trigger workflow on every push
on:
  push:

jobs:
  # Job ID
  matrix-job:

    # Dynamically choose OS from matrix
    runs-on: ${{ matrix.os }}

    # Matrix strategy configuration
    strategy:

      # Continue running remaining jobs even if one fails
      fail-fast: false

      # Matrix combinations
      matrix:

        # Operating systems to test on
        os:
          - ubuntu-latest
          - windows-latest

        # Python versions to test on
        python-version:
          - "3.10"
          - "3.11"
          - "3.12"

        # Exclude specific matrix combination
        exclude:

          # Skip Python 3.10 on Windows
          - os: windows-latest
            python-version: "3.10"

    steps:

      # Checkout repository code
      - name: Checkout Code
        uses: actions/checkout@v4

      # Install Python version from matrix
      - name: Setup Python
        uses: actions/setup-python@v5
        with:

          # Use matrix Python version
          python-version: ${{ matrix.python-version }}

      # Print installed Python version
      - name: Print Python Version
        run: python --version
```

---

# Matrix Build Explanation

## Python Versions
- Python 3.10
- Python 3.11
- Python 3.12

## Operating Systems
- Ubuntu
- Windows

---

# Total Jobs Calculation

Without exclusion:

```text
2 Operating Systems × 3 Python Versions = 6 Jobs
```

With exclusion:

```text
Windows + Python 3.10 excluded
```

Total:

```text
5 Jobs
```

---

# Fail-Fast Behavior

## Default (`true`)
- Stops remaining jobs if one job fails

## `false`
- Other jobs continue running even if one fails

Used in workflow:

```yaml
fail-fast: false
```

---

# What I Learned
- Matrix builds run jobs in parallel
- Matrix strategy reduces duplicate workflow code
- Exclude removes unsupported combinations
- `fail-fast` controls workflow cancellation behavior

---

# Screenshots

## Add Screenshots Here
- PR Workflow Run
- Scheduled Workflow
- Manual Workflow Run
- Matrix Build Parallel Jobs
- Excluded Job Combination

---

# Git Commands Used

## Create Branch

```bash
git checkout -b feature/day41
```

## Add Files

```bash
git add .
```

## Commit Changes

```bash
git commit -m "Completed Day 41 triggers and matrix builds"
```

## Push Branch

```bash
git push origin feature/day41
```

---

# Final Outcome

By the end of Day 41, I learned:
- PR-based automation
- Scheduled workflows
- Manual workflow execution
- Matrix builds
- Parallel job execution
- Exclude rules
- Fail-fast behavior

These are important concepts used in real-world CI/CD pipelines and DevOps automation.