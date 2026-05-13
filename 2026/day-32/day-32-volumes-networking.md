# Day 32 – Docker Volumes & Networking

## Objective
Today's goal was to solve two important Docker problems:

- **Data Persistence** using Docker Volumes
- **Container Communication** using Docker Networks

Containers are ephemeral by nature, meaning data is lost when containers are removed unless storage is managed properly.

---

## Task 1 – Understanding the Problem

# Step 1: Run a PostgreSQL Container

    docker run -d --name postgres-db -e POSTGRES_PASSWORD=admin postgres

# Step 2: Access the Container
    docker exec -it postgres-db bash

# Step 3: Open PostgreSQL
    psql -U postgres

# Step 4: Create Sample Data
    CREATE DATABASE testdb;

    \c testdb

    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50)
    );

    INSERT INTO users(name)
    VALUES ('Kiran'), ('DevOps');

# Step 5: Stop & Remove the Container
    docker stop postgres-db
    docker rm postgres-db

# Step 6: Run a New PostgreSQL Container
    docker run -d --name postgres-db-new -e POSTGRES_PASSWORD=admin postgres

Observation :The data was lost after removing the container.

Reason :
- Containers are ephemeral.
- Without external storage, all container data is deleted when the container is removed.

## Task 2 – Docker Named Volumes

# Step 1: Create a Named Volume
    docker volume create postgres-data
    Verify Volume
    docker volume ls

# Step 2: Run PostgreSQL with Volume
    docker run -d --name postgres-volume-db -e POSTGRES_PASSWORD=admin -v postgres-data:/var/lib/postgresql/data postgres

# Step 3: Create Data Again
    docker exec -it postgres-volume-db bash
    psql -U postgres
    CREATE DATABASE company;

    \c company

    CREATE TABLE employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50)
    );

    INSERT INTO employees(name)
    VALUES ('Alice'), ('Bob');

# Step 4: Stop & Remove Container
    docker stop postgres-volume-db
    docker rm postgres-volume-db

# Step 5: Start New Container with Same Volume
    docker run -d --name postgres-volume-db-new -e POSTGRES_PASSWORD=admin -v postgres-data:/var/lib/postgresql/data postgres

Result
- The data still existed.

Why? The named volume stores data outside the container filesystem, so deleting the container does not remove the data.

Inspect Volume
docker volume inspect postgres-data

## Task 3 – Bind Mounts

# Step 1: Create Local Folder
    mkdir nginx-site
    cd nginx-site
    
# Step 2: Create index.html
    echo "<h1>Hello from Docker Bind Mount</h1>" > index.html

# Step 3: Run Nginx Container
    docker run -d --name nginx-bind -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx

# Step 4: Open Browser

Visit: http://localhost:8080

# Step 5: Edit index.html
    echo "<h1>Updated Page</h1>" > index.html

Refresh the browser and changes appear instantly.


Named Volume vs Bind Mount
Feature	Named Volume	Bind Mount
Managed by Docker	Yes	No
Stored Location	Docker storage area	Host filesystem
Performance	Better for Docker	Depends on host
Portability	High	Lower
Use Case	Database storage	Development files

# Task 4 – Docker Networking Basics
- List Networks
    docker network ls

- Inspect Default Bridge Network
    docker network inspect bridge

- Run Two Containers
    docker run -dit --name container1 ubuntu
    docker run -dit --name container2 ubuntu

- Ping by Name
    docker exec -it container1 ping container2

Result : Failed.

- Ping by IP
    Find IP:

- docker inspect container2
Then ping:
    docker exec -it container1 ping <container2-ip>

Result : Success.

## Task 5 – Custom Docker Networks

# Step 1: Create Custom Network
    docker network create my-app-net

# Step 2: Run Containers on Custom Network
docker run -dit --name app1 --network my-app-net ubuntu
docker run -dit --name app2 --network my-app-net ubuntu

# Step 3: Ping by Name
    docker exec -it app1 ping app2

Result : Success.

Why Custom Networks Allow Name-Based Communication

Docker custom bridge networks include an internal DNS service.

This allows containers to communicate using container names automatically.

The default bridge network does not provide automatic DNS resolution between containers.

## Task 6 – Putting Everything Together

# Step 1: Create Custom Network
    docker network create fullstack-net

# Step 2: Create Volume
    docker volume create mysql-data

# Step 3: Run MySQL Container
    docker run -d --name mysql-db --network fullstack-net -e MYSQL_ROOT_PASSWORD=admin -v mysql-data:/var/lib/mysql mysql

# Step 4: Run App Container
    docker run -dit --name app-container --network fullstack-net ubuntu

# Step 5: Verify Connectivity
    docker exec -it app-container bash
    ping mysql-db

Result : The app container successfully communicated with the database container using the container name.

# Key Learnings
- Containers lose data when removed unless volumes are used.
- Named volumes provide persistent storage.
- Bind mounts connect host files directly to containers.
- Default bridge networks allow IP communication only.
- Custom bridge networks enable container name resolution.
- Docker networking is essential for multi-container applications.

#Commands Used
 Command	Purpose
 
 - docker run	--> Create and run container
 - docker exec	--> Access running container
 - docker stop	--> Stop container
 - docker rm	--> Remove container
 - docker volume create	--> Create Docker volume
 - docker volume ls	--> List volumes
 - docker volume inspect	--> Inspect volume details
 - docker network ls	--> List Docker networks
 - docker network inspect	--> Inspect network
 - docker network create	--> Create custom network
 - ping	--> Test connectivity

## Conclusion

Today’s hands-on practice helped me understand:
  - Why persistent storage matters in Docker
  - How Docker volumes solve data loss
  - How bind mounts help during development
  - How Docker networking enables container communication
  - Why custom networks are preferred in real-world applications

Docker volumes and networking are foundational concepts for building scalable and production-ready containerized applications.

