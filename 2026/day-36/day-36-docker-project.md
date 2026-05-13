# Day 36 – Docker Project: Dockerize a Full Application

## App Chosen
I selected a Node.js + Express application with MongoDB because it represents a real-world backend setup commonly used in production.

---

## What I Learned
- Writing production-ready Dockerfiles
- Using multi-stage builds
- Running containers as non-root users
- Managing services with Docker Compose
- Persisting database data using volumes
- Using environment variables securely
- Implementing healthchecks

---

GITHU_REPO : https://github.com/kiranhingankar/dockerized-nodejs-app.git

## Challenges Faced

### MongoDB Connection Delay
The app started before MongoDB became ready.

### Solution
Added a healthcheck and depends_on condition in Docker Compose.

---

## Final Image Size
~180MB (depends on installed dependencies)

---

## Docker Hub Link
https://hub.docker.com/repository/docker/khingankar/dockerized-nodejs-app/

---

## Commands Used

### Build Containers
docker compose up --build

### Check Running Containers
docker ps

### Push Image
docker push khingankar/dockerized-nodejs-app/