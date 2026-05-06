# Day 11 Challenge – File Ownership (chown & chgrp)

## Files & Directories Created

### Files
- devops-file.txt
- team-notes.txt
- project-config.yaml
- heist-project/vault/gold.txt
- heist-project/plans/strategy.conf
- bank-heist/access-codes.txt
- bank-heist/blueprints.pdf
- bank-heist/escape-plan.txt

### Directories
- app-logs/
- heist-project/
  - vault/
  - plans/
- bank-heist/

---

## Ownership Changes

### Task 2: chown
- devops-file.txt: kiran:kiran → tokyo:kiran → berlin:kiran

### Task 3: chgrp
- team-notes.txt: kiran:kiran → kiran:heist-team

### Task 4: Owner & Group Combined
- project-config.yaml: kiran:kiran → professor:heist-team
- app-logs/: kiran:kiran → berlin:heist-team

### Task 5: Recursive Ownership
- heist-project/ (all files and subdirectories):
  - kiran:kiran → professor:planners

### Task 6: Practice Challenge
- access-codes.txt: kiran:kiran → tokyo:vault-team
- blueprints.pdf: kiran:kiran → berlin:tech-team
- escape-plan.txt: kiran:kiran → nairobi:vault-team

---

## Commands Used

```bash
# View ownership
ls -l
ls -lR

# Create files
touch devops-file.txt
touch team-notes.txt
touch project-config.yaml

# Create directories
mkdir app-logs
mkdir -p heist-project/vault
mkdir -p heist-project/plans
mkdir bank-heist

# Create files inside directories
touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf

touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt

# Create users
sudo useradd tokyo
sudo useradd berlin
sudo useradd nairobi
sudo useradd professor

# Create groups
sudo groupadd heist-team
sudo groupadd planners
sudo groupadd vault-team
sudo groupadd tech-team

# Change owner
sudo chown tokyo devops-file.txt
sudo chown berlin devops-file.txt

# Change group
sudo chgrp heist-team team-notes.txt

# Change owner and group together
sudo chown professor:heist-team project-config.yaml
sudo chown berlin:heist-team app-logs

# Recursive ownership
sudo chown -R professor:planners heist-project/

# Practice challenge ownership
sudo chown tokyo:vault-team bank-heist/access-codes.txt
sudo chown berlin:tech-team bank-heist/blueprints.pdf
sudo chown nairobi:vault-team bank-heist/escape-plan.txt


# What I Learned
1. Every file in Linux has an owner and a group, which control access permissions.
2. The chown command is used to change file ownership, while chgrp changes the group.
3. Using the -R flag allows recursive ownership changes for entire directories, which is essential in real DevOps environments.