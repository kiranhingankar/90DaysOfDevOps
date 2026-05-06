# Day 22 Notes – Git Basics



# Git Commands Reference

## 🔧 Setup & Config

### git config
- Sets user configuration
- Example:
  git config --global user.name "Kiran"

### git init
- Initializes a new Git repository
- Example:
  git init

---

## 🔄 Basic Workflow

### git add
- Adds files to staging area
- Example:
  git add git-commands.md

### git commit
- Saves staged changes to repository
- Example:
  git commit -m "Initial commit"

---

## 👀 Viewing Changes

### git status
- Shows current state of repo
- Example:
  git status

### git log
- Shows commit history
- Example:
  git log

### git diff
- Shows changes between commits or files
- Example:
  git diff


  

## 1. Difference between git add and git commit
git add moves changes to the staging area, while git commit saves those changes permanently in the repository.

## 2. What is staging area?
The staging area is a middle layer where changes are prepared before committing. It allows selective commits instead of committing everything at once.

## 3. What does git log show?
git log shows commit history including commit ID, author, date, and message.

## 4. What is .git folder?
The .git folder stores all repository data like commits, branches, and configuration. If deleted, the project is no longer a Git repository.

## 5. Working directory vs staging vs repository
- Working Directory: Where you edit files
- Staging Area: Where changes are prepared
- Repository: Where changes are permanently stored