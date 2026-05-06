# Day 23 – Git Branching & Working with GitHub

## Task 1: Understanding Branches

### 1. What is a branch in Git?
A branch in Git is a lightweight pointer to a commit. It allows you to work on different features, fixes, or experiments independently without affecting the main codebase.

### 2. Why do we use branches instead of committing everything to `main`?
Branches help isolate work. This prevents breaking the main code, allows parallel development, and makes collaboration easier in teams.

### 3. What is `HEAD` in Git?
`HEAD` is a pointer that indicates the current branch you are working on. It tells Git where the latest commit is in your active branch.

### 4. What happens to your files when you switch branches?
When you switch branches, Git updates your working directory to match the files from that branch. Files may change, appear, or disappear depending on the branch state.

---

## Task 2: Branching Commands — Hands-On

### Commands Used:
```bash
git branch                  # List all branches
git branch feature-1        # Create a new branch
git switch feature-1        # Switch to a branch
git switch -c feature-2     # Create and switch branch
git checkout feature-1      # Switch branch (older method)
git branch -d feature-1     # Delete a branch