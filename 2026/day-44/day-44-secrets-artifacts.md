# Day 44 – Secrets, Artifacts & Running Real Tests in CI

## Overview

Today’s focus was on making GitHub Actions workflows more production-ready by learning how to:

- Secure sensitive data using GitHub Secrets
- Use secrets safely inside workflows
- Upload and download artifacts
- Run real tests inside CI pipelines
- Share files between jobs
- Improve workflow performance using caching

This was the first day where the CI pipeline started doing actual real-world work.

---

# Repository Structure

```bash
github-actions-practice/
│
├── .github/
│   └── workflows/
│       ├── secrets-demo.yml
│       ├── artifacts-demo.yml
│       ├── ci-tests.yml
│       └── cache-demo.yml
│
├── hello.py
└── package.json
```

---

# Task 1 – GitHub Secrets

## Objective

Learn how to securely store sensitive values inside GitHub Actions workflows.

---

## Steps Performed

### Step 1 – Open Repository Settings

Navigate to:

```text
Repository → Settings → Secrets and Variables → Actions
```

---

### Step 2 – Create a Secret

Created a repository secret named:

```text
MY_SECRET_MESSAGE
```

Example value:

```text
this-is-my-secret
```

---

## Workflow File

### `.github/workflows/secrets-demo.yml`

```yaml
name: Secrets Demo

on:
  push:

jobs:
  secrets-test:
    runs-on: ubuntu-latest

    steps:
      - name: Check if secret exists
        run: |
          if [ -n "${{ secrets.MY_SECRET_MESSAGE }}" ]; then
            echo "The secret is set: true"
          else
            echo "The secret is set: false"
          fi

      - name: Attempt to print secret
        run: |
          echo "${{ secrets.MY_SECRET_MESSAGE }}"
```

---

## Output

GitHub automatically masks secret values in logs.

Instead of displaying the real value:

```text
***
```

is shown.

---

## Why Secrets Should Never Be Printed

Printing secrets in CI logs is dangerous because:

- Anyone with Actions access may view them
- Leaked credentials can compromise infrastructure
- Logs may remain accessible for a long time
- Masking should not be relied upon as the only security measure

---

## What I Learned About Secrets

- Secrets should never be hardcoded
- GitHub automatically masks secret values
- Secrets are commonly used for:
  - API keys
  - Cloud credentials
  - Docker credentials
  - SSH keys
  - Deployment tokens

---

# Task 2 – Using Secrets as Environment Variables

## Objective

Use secrets safely without hardcoding sensitive information.

---

## Workflow File

### `.github/workflows/secrets-env.yml`

```yaml
name: Secrets Environment Variables

on:
  push:

jobs:
  env-secret:
    runs-on: ubuntu-latest

    steps:
      - name: Use secret safely
        env:
          SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}

        run: |
          echo "Secret loaded successfully"
          echo "Length of secret: ${#SECRET_MESSAGE}"
```

---

## Additional Secrets Added

Created the following secrets for future Docker workflows:

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

---

# Task 3 – Uploading Artifacts

## Objective

Learn how to save files generated during workflow execution.

---

## Workflow File

### `.github/workflows/artifacts-demo.yml`

```yaml
name: Upload Artifacts Demo

on:
  push:

jobs:
  upload-artifact:
    runs-on: ubuntu-latest

    steps:
      - name: Create report
        run: |
          mkdir reports
          echo "CI Test Report - Success" > reports/report.txt

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: ci-report
          path: reports/report.txt
```

---

## Verification Steps

After workflow completion:

1. Open GitHub Actions
2. Open the latest workflow run
3. Scroll to the Artifacts section
4. Download the uploaded artifact

Successfully verified artifact upload and download functionality.

---

# Task 4 – Downloading Artifacts Between Jobs

## Objective

Share files between multiple jobs inside the same workflow.

---

## Workflow File

### `.github/workflows/artifact-sharing.yml`

```yaml
name: Artifact Sharing Between Jobs

on:
  push:

jobs:
  create-artifact:
    runs-on: ubuntu-latest

    steps:
      - name: Create file
        run: |
          echo "Hello from Job 1" > message.txt

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: shared-file
          path: message.txt

  use-artifact:
    runs-on: ubuntu-latest
    needs: create-artifact

    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: shared-file

      - name: Print file contents
        run: |
          cat message.txt
```

---

## Output

Job 2 successfully downloaded and used the artifact generated in Job 1.

---

## Real-World Use Cases of Artifacts

Artifacts are useful for:

- Test reports
- Coverage reports
- Application binaries
- Build outputs
- Terraform plans
- Logs
- Deployment packages

---

# Task 5 – Running Real Tests in CI

## Objective

Execute actual scripts inside GitHub Actions pipelines.

---

## Python Script

### `scripts/hello.py`

```python
print("CI test successful")
```

---

## Requirements File

### `requirements.txt`

```text
pytest
```

---

## Workflow File

### `.github/workflows/ci-tests.yml`

```yaml
name: Run Real Tests

on:
  push:

jobs:
  test-script:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install dependencies
        run: |
          pip install -r requirements.txt

      - name: Run script
        run: |
          python scripts/hello.py
```

---

## Failure Testing

The script was intentionally broken using:

```python
raise Exception("Pipeline should fail")
```

Result:

```text
Workflow Failed ❌
```

After fixing the script:

```python
print("CI test successful")
```

Result:

```text
Workflow Passed ✅
```

---

## What I Learned

- CI pipelines fail automatically on non-zero exit codes
- GitHub Actions can execute real tests and scripts
- Testing failures intentionally helps understand pipeline behavior

---

# Task 6 – Dependency Caching

## Objective

Improve workflow speed using caching.

---

## Workflow File

### `.github/workflows/cache-demo.yml`

```yaml
name: Cache Dependencies

on:
  push:

jobs:
  cache-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Cache pip packages
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
```

---

# What Is Being Cached?

The following directory is cached:

```text
~/.cache/pip
```

This directory stores downloaded Python packages.

---

# Where Is Cache Stored?

GitHub stores cache on GitHub-hosted infrastructure.

Cache is:

- Repository-specific
- Identified using cache keys
- Reused across workflow runs

---

# Cache Observation

## First Run

- Dependencies downloaded from the internet
- Workflow took longer

## Second Run

- Cache restored successfully
- Dependencies reused from cache
- Workflow completed faster

---

# Screenshots Added

The following screenshots were captured and added:

- Passing workflow run
- Failed workflow run
- Artifact download section
- Cache restore logs

---

# Key Learnings

## Secrets Management

- Secrets must always remain secure
- Environment variables are safer than hardcoding
- GitHub automatically masks secret values

---

## Artifacts

- Artifacts help preserve outputs
- Files can be transferred between jobs
- Useful for debugging and deployments

---

## CI Testing

- CI/CD pipelines validate code automatically
- Broken code immediately fails workflows
- Real testing improves deployment confidence

---

## Caching

- Caching speeds up workflow execution
- Reduces repeated dependency downloads
- Improves CI efficiency significantly

---

# Conclusion

Today’s tasks introduced important real-world CI/CD concepts such as:

- Secure credential handling
- Artifact management
- Real test execution
- Dependency caching

This was a major step toward understanding how production CI/CD pipelines work in modern DevOps environments.

---

# Result

Successfully implemented:

- GitHub Secrets
- Secure environment variables
- Artifact upload and download
- Artifact sharing between jobs
- Real CI testing
- Dependency caching

All workflows executed successfully.

---

# Final Notes

This day provided hands-on experience with:

- Secure CI/CD practices
- Managing workflow outputs
- Testing automation
- Pipeline optimization

Understanding secrets, artifacts, and caching is essential for building reliable and production-ready DevOps pipelines.

---
