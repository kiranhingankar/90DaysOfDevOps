# Day 46 – Reusable Workflows & Composite Actions

<div align="center">

# 🚀 GitHub Actions Reusability in Real DevOps

### Learning how modern engineering teams build scalable CI/CD pipelines

![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-blue?logo=githubactions)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Reusable-success)
![Status](https://img.shields.io/badge/Day-46-red)

</div>

---

# 📚 Overview

In today’s challenge, I learned how professional DevOps teams avoid duplicating GitHub Actions workflows by using:

- 🔁 Reusable Workflows
- 🧩 Composite Actions
- ⚡ Shared Automation
- 📦 Modular CI/CD Architecture

Instead of rewriting the same YAML files in every repository, reusable workflows allow pipelines to be called like functions using `workflow_call`.

This approach helps teams build:

✅ Scalable CI/CD pipelines  
✅ Cleaner automation  
✅ Easier maintenance  
✅ Production-grade GitHub Actions architecture  
✅ Reusable DevOps systems  

---

# 🎯 Challenge Goals

By the end of this challenge, I successfully created:

- ✅ A reusable workflow
- ✅ A caller workflow
- ✅ Workflow outputs
- ✅ A custom composite action
- ✅ A reusable automation structure
- ✅ Complete markdown documentation

---

# 🧠 Task 1 – Understanding `workflow_call`

---

## ❓ What is a Reusable Workflow?

A reusable workflow is a GitHub Actions workflow that can be called by another workflow.

Instead of duplicating CI/CD pipelines across repositories, teams can create one reusable workflow and invoke it anywhere.

Reusable workflows improve:
- Scalability
- Maintainability
- Reusability
- Standardization

---

## ❓ What is `workflow_call`?

`workflow_call` is a special trigger in GitHub Actions that allows a workflow to be executed from another workflow.

Example:

```yaml
on:
  workflow_call:
```

---

## ❓ Reusable Workflow vs Regular Action

| Feature | Reusable Workflow | Regular Action |
|---|---|---|
| Purpose | Reuse full workflows | Reuse steps |
| Triggered By | `workflow_call` | `uses:` |
| Can contain jobs | ✅ Yes | ❌ No |
| Best for | Full CI/CD pipelines | Reusable logic |

---

## ❓ Where Must Reusable Workflows Live?

Reusable workflows must be stored inside:

```bash
.github/workflows/
```

---

# 🛠 Task 2 – Create a Reusable Workflow

---

# 📄 File Structure

```bash
.github/
└── workflows/
    ├── reusable-build.yml
    └── call-build.yml
```

---

# 📄 `.github/workflows/reusable-build.yml`

```yaml
name: Reusable Build Workflow

on:
  workflow_call:

    inputs:
      app_name:
        description: "Application name"
        required: true
        type: string

      environment:
        description: "Deployment environment"
        required: true
        type: string
        default: staging

    secrets:
      docker_token:
        required: true

    outputs:
      build_version:
        description: "Generated build version"
        value: ${{ jobs.build.outputs.build_version }}

jobs:
  build:
    name: Build Application

    runs-on: ubuntu-latest

    outputs:
      build_version: ${{ steps.version.outputs.build_version }}

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Build Details
        run: |
          echo "🚀 Building ${{ inputs.app_name }}"
          echo "🌍 Environment: ${{ inputs.environment }}"
          echo "🔐 Docker token exists: ${{ secrets.docker_token != '' }}"

      - name: Generate Build Version
        id: version
        run: |
          SHORT_SHA=$(echo $GITHUB_SHA | cut -c1-7)
          VERSION="v1.0-$SHORT_SHA"

          echo "build_version=$VERSION" >> $GITHUB_OUTPUT

      - name: Print Version
        run: |
          echo "📦 Build Version: ${{ steps.version.outputs.build_version }}"
```

---

# 🔍 Explanation

## ✅ Inputs

This reusable workflow accepts:

| Input | Type | Required | Default |
|---|---|---|---|
| `app_name` | string | ✅ | - |
| `environment` | string | ✅ | `staging` |

---

## ✅ Secrets

| Secret | Required |
|---|---|
| `docker_token` | ✅ |

---

## ✅ Outputs

| Output | Description |
|---|---|
| `build_version` | Dynamically generated version |

---

# 📞 Task 3 – Create Caller Workflow

---

# 📄 `.github/workflows/call-build.yml`

```yaml
name: Call Reusable Workflow

on:
  push:
    branches:
      - main

jobs:

  build:
    uses: ./.github/workflows/reusable-build.yml

    with:
      app_name: "my-web-app"
      environment: "production"

    secrets:
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  print-version:
    name: Print Workflow Output

    needs: build

    runs-on: ubuntu-latest

    steps:
      - name: Print Build Version
        run: |
          echo "📦 Version: ${{ needs.build.outputs.build_version }}"
```

---

# 🔍 What This Workflow Does

## ✅ Trigger

Runs automatically on:

```yaml
push:
  branches:
    - main
```

---

## ✅ Calls Reusable Workflow

```yaml
uses: ./.github/workflows/reusable-build.yml
```

---

## ✅ Passes Inputs

```yaml
with:
  app_name: "my-web-app"
  environment: "production"
```

---

## ✅ Passes Secrets

```yaml
secrets:
  docker_token: ${{ secrets.DOCKER_TOKEN }}
```

---

# 📤 Task 4 – Workflow Outputs

---

# ✅ Generating Outputs

Inside reusable workflow:

```yaml
outputs:
  build_version:
```

---

# ✅ Accessing Outputs

Inside caller workflow:

```yaml
${{ needs.build.outputs.build_version }}
```

---

# 💡 Why Outputs Matter

Workflow outputs enable:

- 🔁 Cross-job communication
- 📦 Dynamic versioning
- 🚀 Production pipeline orchestration
- ⚡ Workflow chaining

---

# 🧩 Task 5 – Create Composite Action

---

# 📄 File Structure

```bash
.github/
└── actions/
    └── setup-and-greet/
        └── action.yml
```

---

# 📄 `.github/actions/setup-and-greet/action.yml`

```yaml
name: Setup and Greet

description: Custom Composite Action

inputs:

  name:
    description: User name
    required: true

  language:
    description: Greeting language
    required: false
    default: "en"

outputs:

  greeted:
    description: Greeting status
    value: ${{ steps.greet.outputs.greeted }}

runs:
  using: "composite"

  steps:

    - name: Greeting User
      id: greet
      shell: bash

      run: |

        if [ "${{ inputs.language }}" = "en" ]; then
          echo "👋 Hello, ${{ inputs.name }}!"

        elif [ "${{ inputs.language }}" = "es" ]; then
          echo "👋 Hola, ${{ inputs.name }}!"

        else
          echo "👋 Hi, ${{ inputs.name }}!"
        fi

        echo "📅 Current Date: $(date)"
        echo "💻 Runner OS: $RUNNER_OS"

        echo "greeted=true" >> $GITHUB_OUTPUT
```

---

# ▶ Workflow Using Composite Action

# 📄 `.github/workflows/composite-demo.yml`

```yaml
name: Composite Action Demo

on:
  workflow_dispatch:

jobs:

  demo:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Run Composite Action
        id: greet

        uses: ./.github/actions/setup-and-greet

        with:
          name: "Kiran"
          language: "en"

      - name: Print Action Output
        run: |
          echo "✅ Greeted: ${{ steps.greet.outputs.greeted }}"
```

---

# 📊 Task 6 – Reusable Workflow vs Composite Action

| Feature | Reusable Workflow | Composite Action |
|---|---|---|
| Triggered by | `workflow_call` | `uses:` |
| Can contain jobs? | ✅ Yes | ❌ No |
| Can contain multiple steps? | ✅ Yes | ✅ Yes |
| Lives where? | `.github/workflows/` | Any directory with `action.yml` |
| Accept secrets directly? | ✅ Yes | ❌ No |
| Best for | Full CI/CD pipelines | Shared step logic |

---

# 📸 Workflow Screenshots

## ✅ Add Screenshot Here

Example:

```md
![Reusable Workflow](./images/reusable-workflow.png)
```

Suggested screenshots:
- Caller workflow execution
- Reusable workflow logs
- Composite action logs
- Output printing

---

# 🧪 Verification Checklist

| Task | Status |
|---|---|
| Reusable workflow created | ✅ |
| Caller workflow created | ✅ |
| Workflow inputs working | ✅ |
| Workflow secrets working | ✅ |
| Workflow outputs working | ✅ |
| Composite action created | ✅ |
| Composite action outputs working | ✅ |
| Documentation completed | ✅ |

---

# 💡 Key Learnings

## 🔁 Reusable Workflows

Best for:
- Enterprise pipelines
- Multi-job workflows
- Shared CI/CD architecture
- Cross-repository automation

---

## 🧩 Composite Actions

Best for:
- Shared reusable logic
- Repeated setup tasks
- Small automation blocks
- Common scripts

---

# 🚀 Real-World DevOps Takeaway

Today’s challenge felt like real production engineering.

The biggest lesson:

> DevOps is not just about automation.
> It’s about building automation that scales.

Modern engineering teams avoid duplication by designing reusable systems.

Reusable workflows and composite actions make CI/CD:
- Cleaner
- Faster
- Easier to maintain
- More scalable

---
