📘 Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick


🔀 Task 1: Git Merge
✅ What I Did
Created feature-login branch and added commits
Merged into main → observed fast-forward merge
Created feature-signup branch
Added commit in main before merging → resulted in merge commit
Tried creating a merge conflict by editing the same line in both branches
🧠 Observations

🔹 What is a Fast-Forward Merge?
A fast-forward merge happens when there are no new commits in the target branch. Git simply moves the pointer forward.

🔹 When does Git create a Merge Commit?
When both branches have new commits, Git combines histories using a merge commit.

🔹 What is a Merge Conflict?
Occurs when the same part of a file is modified in different branches. Git cannot decide which change to keep.

🔁 Task 2: Git Rebase
✅ What I Did
Created feature-dashboard branch and added commits
Added a new commit in main
Rebasing feature-dashboard onto main
Visualized history using:
git log --oneline --graph --all
🧠 Observations

🔹 What does Rebase do?
Rebase moves commits from one branch and reapplies them on top of another branch.

🔹 How is it different from Merge?

Merge → Keeps history with branches
Rebase → Creates clean, linear history

🔹 Why avoid rebasing shared commits?
Rewriting history can cause conflicts for others working on the same branch.

🔹 When to use Rebase vs Merge?

Rebase → For clean history (local work)
Merge → For collaboration and preserving history
🧩 Task 3: Squash vs Merge Commit
✅ What I Did
Created feature-profile with multiple small commits
Used --squash merge → resulted in 1 commit
Created feature-settings and merged normally → preserved all commits
🧠 Observations

🔹 What does Squash Merge do?
Combines all commits into a single commit before merging.

🔹 When to use Squash Merge?
When you want a clean and simple commit history.

🔹 Trade-off?

✔ Clean history
❌ Lose detailed commit history
📦 Task 4: Git Stash
✅ What I Did
Made changes without committing
Used git stash to save work
Switched branches and came back
Applied stash using git stash pop
Created multiple stashes and listed them
🧠 Observations

🔹 Difference between stash pop and stash apply

pop → applies and removes stash
apply → applies but keeps stash

🔹 When to use Stash?
When switching tasks without committing incomplete work.

🎯 Task 5: Cherry Pick
✅ What I Did
Created feature-hotfix branch with multiple commits
Cherry-picked only one commit into main
🧠 Observations

🔹 What does Cherry Pick do?
Applies a specific commit from one branch to another.

🔹 When to use it?
For applying bug fixes or specific changes without merging entire branch.

🔹 What can go wrong?
Duplicate commits
Conflicts
Messy history if overused



🛠️ Commands Learned
git merge <branch>
git rebase <branch>
git merge --squash <branch>
git stash
git stash pop
git stash apply
git stash list
git cherry-pick <commit-hash>
git log --oneline --graph --all
🚀 Key Takeaway

Today I learned how to manage branches efficiently using:

Merge vs Rebase
Clean history with Squash
Temporary saves using Stash
Selective commits using Cherry Pick

These are essential Git skills for real-world development and collaboration