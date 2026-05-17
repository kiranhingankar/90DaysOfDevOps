# Docker Cheat Sheet

## Container Commands

| Command | Usage |
|---|---|
| `docker run nginx` | Run a container from an image |
| `docker run -it ubuntu bash` | Run container in interactive mode |
| `docker run -d nginx` | Run container in detached mode |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop <container>` | Stop a running container |
| `docker start <container>` | Start a stopped container |
| `docker restart <container>` | Restart a container |
| `docker rm <container>` | Remove a container |
| `docker exec -it <container> bash` | Access container shell |
| `docker logs <container>` | View container logs |
| `docker inspect <container>` | View detailed container info |

---

## Image Commands

| Command | Usage |
|---|---|
| `docker pull nginx` | Download image from Docker Hub |
| `docker images` | List local images |
| `docker build -t myapp:v1 .` | Build image from Dockerfile |
| `docker tag myapp:v1 username/myapp:v1` | Tag image |
| `docker push username/myapp:v1` | Push image to Docker Hub |
| `docker rmi <image>` | Remove image |
| `docker image prune` | Remove unused images |

---

## Volume Commands

| Command | Usage |
|---|---|
| `docker volume create myvolume` | Create named volume |
| `docker volume ls` | List volumes |
| `docker volume inspect myvolume` | Inspect volume |
| `docker volume rm myvolume` | Remove volume |
| `docker run -v myvolume:/data nginx` | Mount named volume |

---

## Bind Mounts

| Command | Usage |
|---|---|
| `docker run -v $(pwd):/app nginx` | Mount local directory into container |

---

## Network Commands

| Command | Usage |
|---|---|
| `docker network create mynet` | Create custom network |
| `docker network ls` | List networks |
| `docker network inspect mynet` | Inspect network |
| `docker network connect mynet container1` | Connect container to network |
| `docker run --network=mynet nginx` | Run container on custom network |

---

## Docker Compose Commands

| Command | Usage |
|---|---|
| `docker compose up` | Start services |
| `docker compose up -d` | Start services in detached mode |
| `docker compose down` | Stop and remove services |
| `docker compose down -v` | Remove services and volumes |
| `docker compose ps` | List compose services |
| `docker compose logs` | View compose logs |
| `docker compose build` | Build compose services |

---

## Cleanup Commands

| Command | Usage |
|---|---|
| `docker system df` | Check Docker disk usage |
| `docker system prune` | Remove unused Docker data |
| `docker container prune` | Remove stopped containers |
| `docker volume prune` | Remove unused volumes |
| `docker network prune` | Remove unused networks |

---

## Dockerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Base image |
| `RUN` | Execute commands during build |
| `COPY` | Copy files into image |
| `ADD` | Copy files + extract archives/URLs |
| `WORKDIR` | Set working directory |
| `EXPOSE` | Document container port |
| `ENV` | Set environment variables |
| `CMD` | Default command to run |
| `ENTRYPOINT` | Main executable for container |

---

## Common Port Mapping

| Command | Meaning |
|---|---|
| `-p 8080:80` | Map host port 8080 to container port 80 |

---

## Helpful Tips

- Containers are temporary, images are templates.
- Use `.dockerignore` to reduce image size.
- Multi-stage builds create smaller production images.
- Named volumes persist data after container removal.
- Custom networks allow containers to communicate using container names.