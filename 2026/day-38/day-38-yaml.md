# Day 38 – YAML Basics

## Introduction

Today I learned the basics of YAML, which is widely used in DevOps tools like Docker Compose, Kubernetes, GitHub Actions, Jenkins pipelines, and Ansible.

YAML is human-readable and indentation-based, which makes formatting very important.

---

# Task 1: Key-Value Pairs

Created `person.yaml` with basic information.

## person.yaml

```yaml
name: Kiran Hingankar
role: DevOps Learner
experience_years: 1
learning: true
```

### Observation

- YAML uses `key: value` format
- Booleans use `true` or `false`
- Tabs should never be used

---

# Task 2: Lists

Added lists to `person.yaml`.

## Updated person.yaml

```yaml
name: Kiran Hingankar
role: DevOps Learner
experience_years: 1
learning: true

tools:
  - Docker
  - Git
  - Linux
  - Jenkins
  - Kubernetes

hobbies: [coding, gaming, music]
```

## Two Ways to Write Lists in YAML

### 1. Block Style

```yaml
tools:
  - Docker
  - Git
  - Linux
```

### 2. Inline Style

```yaml
tools: [Docker, Git, Linux]
```

---

# Task 3: Nested Objects

Created `server.yaml` using nested objects.

## server.yaml

```yaml
server:
  name: web-server-01
  ip: 192.168.1.10
  port: 8080

database:
  host: localhost
  name: app_db

  credentials:
    user: admin
    password: secret123
```

## Observation

Using tabs instead of spaces causes YAML validation errors because YAML only supports spaces for indentation.

---

# Task 4: Multi-line Strings

Added startup scripts using `|` and `>` styles.

## Updated server.yaml

```yaml
server:
  name: web-server-01
  ip: 192.168.1.10
  port: 8080

database:
  host: localhost
  name: app_db

  credentials:
    user: admin
    password: secret123

startup_script_literal: |
  #!/bin/bash
  echo "Starting application..."
  systemctl start nginx
  systemctl start docker

startup_script_folded: >
  #!/bin/bash
  echo "Starting application..."
  systemctl start nginx
  systemctl start docker
```

## Literal Block Style (`|`)

Preserves line breaks exactly as written.

```yaml
startup_script_literal: |
  echo "Hello"
  echo "World"
```

## Folded Block Style (`>`)

Combines multiple lines into a single line.

```yaml
startup_script_folded: >
  echo "Hello"
  echo "World"
```

## When to Use

| Style | Usage |
|-------|--------|
| `|` | Scripts, commands, configuration blocks |
| `>` | Long paragraphs or readable text |

---

# Task 5: YAML Validation

Installed and used `yamllint` to validate YAML files.

## Commands Used

```bash
sudo apt install yamllint -y
yamllint person.yaml
yamllint server.yaml
```

## Error Encountered

```bash
syntax error: found character '\t' that cannot start any token
```

## Fix

Replaced tabs with spaces and validated again successfully.

---

# Task 6: Spot the Difference

## Correct YAML

```yaml
name: devops
tools:
  - docker
  - kubernetes
```

## Broken YAML

```yaml
name: devops
tools:
- docker
  - kubernetes
```

## What's Wrong?

The indentation is inconsistent.

`- docker` is not properly indented under `tools:` which breaks the YAML structure.

---

# Key Learnings

1. YAML is highly sensitive to indentation.
2. Spaces must be used instead of tabs.
3. Lists can be written using block style or inline style.
4. Nested objects help organize structured data.
5. `|` preserves line breaks while `>` folds text into a single line.
6. Validation tools like `yamllint` help catch syntax mistakes quickly.

---

# Folder Structure

```bash
2026/day-38/
├── person.yaml
├── server.yaml
└── day-38-yaml.md
```

---

# Conclusion

Today’s practice helped me understand the fundamentals of YAML, which is essential for writing CI/CD pipelines and infrastructure configuration files in DevOps.