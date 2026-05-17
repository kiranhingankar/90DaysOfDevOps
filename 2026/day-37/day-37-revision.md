# Day 37 – Docker Revision & Self-Assessment

## Self-Assessment Checklist

| Topic | Status |
|---|---|
| Run a container from Docker Hub (interactive + detached) | Can Do |
| List, stop, remove containers and images | Can Do |
| Explain image layers and how caching works | Shaky |
| Write a Dockerfile from scratch with FROM, RUN, COPY, WORKDIR, CMD | Can Do |
| Explain CMD vs ENTRYPOINT | Shaky |
| Build and tag a custom image | Can Do |
| Create and use named volumes | Can Do |
| Use bind mounts | Can Do |
| Create custom networks and connect containers | Can Do |
| Write a docker-compose.yml for a multi-container app | Can Do |
| Use environment variables and .env files in Compose | Can Do |
| Write a multi-stage Dockerfile | Can Do |
| Push an image to Docker Hub | Can Do |
| Use healthchecks and depends_on | Can Do |

---

# Quick-Fire Questions

## 1. What is the difference between an image and a container?

- An image is a blueprint/template.
- A container is a running instance of an image.

---

## 2. What happens to data inside a container when you remove it?

- Container data is lost unless stored in volumes or bind mounts.

---

## 3. How do two containers on the same custom network communicate?

- They communicate using container names as hostnames.

Example: ping mongodb

--- 
## 4. What does docker compose down -v do differently from docker compose down?
- docker compose down removes containers and networks.
- docker compose down -v also removes volumes.

## 5. Why are multi-stage builds useful?
- They reduce image size by separating build dependencies from production runtime.

## 6. What is the difference between COPY and ADD?
- COPY only copies files/directories.
- ADD can also extract archives and download URLs.

## 7. What does -p 8080:80 mean?
- Maps host port 8080 to container port 80.

## 8. How do you check how much disk space Docker is using?
- docker system df


## Weak Areas Revisited
1. CMD vs ENTRYPOINT

# CMD
- Provides default arguments/commands.
- Can be overridden easily.

Example: CMD ["npm", "start"]

# ENTRYPOINT
- Defines the main container executable.
- Harder to override.

Example: ENTRYPOINT ["python3"]

2. Image Layers & Caching
- Every Dockerfile instruction creates a layer.
- Docker reuses unchanged layers from cache.
- Efficient layer ordering speeds up builds.

# Best Practice:
- Put dependency installation before copying app source code.

Example:

COPY package.json .
RUN npm install

COPY . .
Revision Summary

- Today was focused on revising core Docker concepts from Days 29–36.

## Key takeaways:

- Docker volumes persist data.
- Multi-stage builds reduce image size.
- Compose simplifies multi-container setups.
- Healthchecks improve service reliability.
- Docker caching speeds up builds significantly.