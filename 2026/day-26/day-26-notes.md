# 📅 Day 26 – GitHub CLI (`gh`) Notes

## 📌 Overview

Today I learned how to use the GitHub CLI (`gh`) to manage repositories, issues, pull requests, and workflows directly from the terminal. This helps reduce context switching and improves productivity.

---

## 🔹 Task 1: Install & Authenticate

### Install

```bash
# Ubuntu
sudo apt install gh

# Mac
brew install gh

# Windows
winget install GitHub.cli
```

### Authenticate

```bash
gh auth login
```

### Verify Login

```bash
gh auth status
```

### ✅ Authentication Methods

* Browser-based (HTTPS)
* Personal Access Token (PAT)
* SSH

---

## 🔹 Task 2: Repositories

```bash
# Create repo
gh repo create my-repo --public --add-readme

# Clone repo
gh repo clone owner/repo

# List repos
gh repo list

# View repo
gh repo view owner/repo

# Open in browser
gh repo view --web

# Delete repo
gh repo delete owner/repo
```

---

## 🔹 Task 3: Issues

```bash
# Create issue
gh issue create --title "Bug" --body "Fix this issue"

# List issues
gh issue list

# View issue
gh issue view <issue-number>

# Close issue
gh issue close <issue-number>
```

### ✅ Use in Automation

* Auto-create issues from scripts
* Track CI/CD failures
* Export issue data using `--json`

---

## 🔹 Task 4: Pull Requests

```bash
# Create branch and push
git checkout -b feature-branch
git add .
git commit -m "feature added"
git push origin feature-branch

# Create PR
gh pr create --fill

# List PRs
gh pr list

# View PR
gh pr view <pr-number>

# Checkout PR
gh pr checkout <pr-number>

# Review PR
gh pr review --approve

# Merge PR
gh pr merge <pr-number> --squash
```

### ✅ Merge Methods

* Merge commit
* Squash
* Rebase

---

## 🔹 Task 5: GitHub Actions

```bash
# List workflow runs
gh run list

# View workflow run
gh run view <run-id>
```

### ✅ Use in CI/CD

* Monitor pipelines
* Debug failures
* Automate checks

---

## 🔹 Task 6: Advanced Commands

```bash
# GitHub API
gh api repos/:owner/:repo

# Gist
gh gist create file.txt

# Release
gh release create v1.0.0

# Alias
gh alias set co "pr checkout"

# Search repos
gh search repos devops
```

---

## 🧠 Key Learnings

* `gh` reduces context switching between terminal and browser
* Helps automate GitHub workflows
* Useful for DevOps and CI/CD pipelines
* Supports JSON output for scripting

---

## 🚀 Conclusion

GitHub CLI is a powerful tool that enables efficient repository management, faster workflows, and better automation — all from the terminal.
