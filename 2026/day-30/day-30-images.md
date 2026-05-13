# Day 30 – Docker Images & Container Lifecycle

## Objective
Today I learned how Docker images and containers work internally, including:
- Docker images
- Image layers and caching
- Container lifecycle
- Working with running containers
- Docker cleanup commands

---

## Task 1: Docker Images

# Pull Docker Images
- docker pull nginx
- docker pull ubuntu
- docker pull alpine

Purpose : docker pull downloads images from Docker Hub to the local machine.

# List All Images
- docker images

Purpose :
Displays -
1. Repository name
2. Tag
3. Image ID
4. Created date
5. Image size

Observation :
- Ubuntu image is much larger than Alpine.
- Alpine is lightweight because it contains minimal packages and uses BusyBox.

# Inspect an Image
- docker inspect nginx

Information Found :
Image ID
Architecture
Environment variables
Layers
Entrypoint
Creation time

# Remove an Image
- docker rmi ubuntu
Purpose : Removes unused Docker images from the system.


## Task 2: Image Layers

# View Image History
- docker image history nginx
Observation :
- Every line represents a Docker image layer.
- Some layers show sizes while some show 0B.
- Why Docker Uses Layers

Docker layers:
Improve build speed
Reuse cached layers
Reduce storage usage
Make image distribution faster

Example :If multiple images use the same base image, Docker stores that layer only once.


## Task 3: Container Lifecycle

# Create Container Without Starting
- docker create --name mycontainer nginx
Purpose : Creates a container in the Created state.

# Start Container
- docker start mycontainer
Purpose : Starts the container.

# Pause Container
- docker pause mycontainer
Purpose : Temporarily freezes container processes.

# Unpause Container
- docker unpause mycontainer
Purpose : Resumes paused processes.

# Stop Container
- docker stop mycontainer
Purpose : Gracefully stops the container.

# Restart Container
- docker restart mycontainer
Purpose : Stops and starts the container again

# Kill Container
- docker kill mycontainer
Purpose : Forcefully stops the container immediately.

# Remove Container
- docker rm mycontainer
Purpose : Deletes the container permanently.

## Task 4: Working with Running Containers

# Run Nginx in Detached Mode
-  docker run -d --name nginx-server -p 8080:80 nginx
Purpose :
-d : runs container in background
-p : maps ports

# View Logs
- docker logs nginx-server
Purpose : Displays container logs.

# View Real-Time Logs
- docker logs -f nginx-server
Purpose : Streams live logs continuously.

# Access Container Shell
- docker exec -it nginx-server /bin/bash
Purpose : Opens an interactive terminal inside the container.

# Run Single Command Inside Container
- docker exec nginx-server ls /
Purpose : Executes a command inside the running container.

# Inspect Container
- docker inspect nginx-server

Information Found :
IP Address
Port mappings
Mounts
Network settings
Container state


## Task 5: Cleanup

# Stop All Running Containers
- docker stop $(docker ps -q)
Purpose : Stops every running container.

# Remove All Stopped Containers
- docker container prune
Purpose : Deletes all stopped containers.

# Remove Unused Images
- docker image prune -a
Purpose : Removes unused Docker images.

# Check Docker Disk Usage
- docker system df
Purpose : Shows Docker disk usage statistics.

Key Learnings :
- Docker images are templates used to create containers.
- Containers are running instances of images.
- Docker layers improve efficiency through caching.
- Alpine images are lightweight and optimized.
- Containers move through multiple lifecycle states:
- Created
- Running
- Paused
- Exited
- Removed


Conclusion :
Today’s practice helped me understand how Docker manages images, layers, and containers efficiently. I also learned how containers transition through different lifecycle states and how Docker optimizes storage using reusable layers.