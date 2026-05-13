# Day 34 – Docker Compose: Real-World Multi-Container Apps

## Objective
Today I learned how to build and manage production-like multi-container applications using Docker Compose.

This setup includes:
- Flask Web App
- MySQL Database
- Redis Cache

I also explored:
- depends_on
- healthchecks
- restart policies
- custom Dockerfiles
- named networks
- named volumes
- scaling services

---

# Project Structure

```bash
day-34/
│
├── docker-compose.yml
├── day-34-compose-advanced.md
│
└── app/
    ├── Dockerfile
    ├── requirements.txt
    └── app.py
```

---

# Task 1 – Build a 3-Service Stack

## docker-compose.yml

```yaml
services:
  web:
    build: ./app
    container_name: flask-web
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
    environment:
      MYSQL_HOST: db
      MYSQL_USER: root
      MYSQL_PASSWORD: rootpass
      MYSQL_DB: demo
      REDIS_HOST: redis
    networks:
      - backend
    labels:
      project: "day34"
      service: "web"

  db:
    image: mysql:8.0
    container_name: mysql-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: demo
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-prootpass"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - backend
    labels:
      project: "day34"
      service: "database"

  redis:
    image: redis:latest
    container_name: redis-cache
    ports:
      - "6379:6379"
    networks:
      - backend
    labels:
      project: "day34"
      service: "cache"

networks:
  backend:

volumes:
  mysql_data:
```

---

# Flask Application

## app/app.py

```python
from flask import Flask
import mysql.connector
import redis
import os

app = Flask(__name__)

@app.route('/')
def home():
    try:
        db = mysql.connector.connect(
            host=os.environ.get("MYSQL_HOST"),
            user=os.environ.get("MYSQL_USER"),
            password=os.environ.get("MYSQL_PASSWORD"),
            database=os.environ.get("MYSQL_DB")
        )

        redis_client = redis.Redis(
            host=os.environ.get("REDIS_HOST"),
            port=6379
        )

        redis_client.set("message", "Docker Compose is working!")
        msg = redis_client.get("message").decode("utf-8")

        return f"MySQL + Redis Connected Successfully! Message: {msg}"

    except Exception as e:
        return f"Error: {e}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## app/requirements.txt

```txt
flask
mysql-connector-python
redis
```

---

## app/Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Task 2 – depends_on & Healthchecks

## What I Learned

- `depends_on` ensures service startup order
- But containers may start before services are actually ready
- Healthchecks solve this issue

## Healthcheck Used

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-prootpass"]
  interval: 10s
  timeout: 5s
  retries: 5
```

## Result

When I restarted the stack:
- MySQL started first
- Compose waited for MySQL to become healthy
- Then Flask app started successfully

Command used:

```bash
docker compose down
docker compose up
```

---

# Task 3 – Restart Policies

## restart: always

```yaml
restart: always
```

### Behavior
- Container restarts automatically
- Works even after Docker daemon restart

### Test

I killed the MySQL container:

```bash
docker kill mysql-db
```

Docker restarted it automatically.

---

## restart: on-failure

```yaml
restart: on-failure
```

### Behavior
- Restarts only if container exits with error
- Does NOT restart if manually stopped

---

## When to Use Which?

| Policy | Use Case |
|---|---|
| always | Databases, critical backend services |
| on-failure | Batch jobs, scripts, temporary workers |
| no | Debugging or one-time containers |

---

# Task 4 – Custom Dockerfiles in Compose

Instead of pulling a ready-made image, I built my own Flask app image using:

```yaml
build: ./app
```

## Rebuild Command

```bash
docker compose up --build
```

This rebuilds the image and restarts containers in one command.

---

# Task 5 – Named Networks & Volumes

## Named Network

```yaml
networks:
  backend:
```

Benefits:
- Better isolation
- Easier communication between containers
- More production-like setup

---

## Named Volume

```yaml
volumes:
  mysql_data:
```

Benefits:
- Persistent database storage
- Data survives container deletion

---

# Task 6 – Scaling

## Scale Command

```bash
docker compose up --scale web=3
```

## What Happened?

Docker tried to create:
- web_1
- web_2
- web_3

But port conflicts occurred because all replicas wanted to use:

```yaml
ports:
  - "5000:5000"
```

Only one container can bind to the same host port.

---

# Why Simple Scaling Breaks

Port mapping causes conflicts because:
- Multiple containers cannot share the same host port
- Load balancing is required for real scaling

In production:
- Use Nginx or Traefik as reverse proxy
- Use Docker Swarm or Kubernetes for orchestration

---

# Commands Used

## Build and Start

```bash
docker compose up --build
```

## Run in Background

```bash
docker compose up -d
```

## Stop Everything

```bash
docker compose down
```

## View Running Containers

```bash
docker ps
```

## View Logs

```bash
docker compose logs -f
```

## Scale Web App

```bash
docker compose up --scale web=3
```

---

# Key Learnings

- Docker Compose simplifies multi-container management
- Healthchecks improve reliability
- Restart policies improve availability
- Named volumes preserve important data
- Networks isolate services securely
- Scaling containers requires load balancing

---

# Conclusion

Today I built a production-style Docker Compose setup with:
- Flask
- MySQL
- Redis

I also learned how real-world containerized applications manage:
- dependencies
- health checks
- persistence
- recovery
- scaling

This was a major step toward understanding production DevOps environments.