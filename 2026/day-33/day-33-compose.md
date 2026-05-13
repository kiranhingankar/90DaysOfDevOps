# Day 33 – Docker Compose: Multi-Container Basics

## Objective
Learn how to manage multi-container applications using Docker Compose.

Docker Compose helps automate:
- Container creation
- Networking
- Volume management
- Environment variables
- Multi-container communication

---

# Task 1 – Install & Verify Docker Compose

## Check Docker Compose Version

- docker compose version
    Example Output : Docker Compose version v2.x.x


# Task 2 – First Docker Compose File

    - Create Project Directory
        mkdir compose-basics
        cd compose-basics

    - Create docker-compose.yml
    services:
        nginx:
            image: nginx:latest
            container_name: nginx-compose
            ports:
                - "8080:80"

    - Start Container
        docker compose up
    
    - Run in Detached Mode
        docker compose up -d

    - Verify Running Containers
        docker ps
    
    - Access Nginx in Browser :http://localhost:8080

    - Stop & Remove Container
        docker compose down


# Task 3 – WordPress + MySQL Multi-Container Setup
    Create docker-compose.yml
        services:

            wordpress:
                image: wordpress:latest
                container_name: wordpress-app
                ports:
                - "8081:80"

                environment:
                    WORDPRESS_DB_HOST: mysql
                    WORDPRESS_DB_USER: wpuser
                    WORDPRESS_DB_PASSWORD: wppassword
                    WORDPRESS_DB_NAME: wordpressdb

                depends_on:
                    - mysql

            mysql:
                image: mysql:5.7
                container_name: mysql-db

                restart: always

                environment:
                    MYSQL_DATABASE: wordpressdb
                    MYSQL_USER: wpuser
                    MYSQL_PASSWORD: wppassword
                    MYSQL_ROOT_PASSWORD: rootpassword

                volumes:
                    - mysql_data:/var/lib/mysql

            volumes:
                mysql_data:

    - Start WordPress + MySQL
        docker compose up -d

    - Verify Running Services
        docker compose ps

    Access WordPress : http://localhost:8081

Complete WordPress installation from the browser.

    - Verify Persistent Storage
        Stop Containers
            docker compose down

        Restart Containers
            docker compose up -d

    Observation : 
        - WordPress data remains available after restart.
        - Data persistence works because MySQL uses a named volume.


#Task 4 – Important Docker Compose Commands
    Command	Usage
    docker compose up	Start all services
    docker compose up -d	Start services in detached/background mode
    docker compose ps	View running services
    docker compose logs	View logs of all services
    docker compose logs wordpress	View logs of specific service
    docker compose stop	Stop services without removing
    docker compose start	Start stopped services
    docker compose down	Remove containers and networks
    docker compose down -v	Remove containers, networks, and volumes
    docker compose up --build	Rebuild services after changes


#Task 5 – Environment Variables
    Create .env File
        MYSQL_DATABASE=wordpressdb
        MYSQL_USER=wpuser
        MYSQL_PASSWORD=wppassword
        MYSQL_ROOT_PASSWORD=rootpassword
    
    Updated docker-compose.yml
    services:

        wordpress:
            image: wordpress:latest

            ports:
                - "8081:80"

            environment:
                WORDPRESS_DB_HOST: mysql
                WORDPRESS_DB_USER: ${MYSQL_USER}
                WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
                WORDPRESS_DB_NAME: ${MYSQL_DATABASE}

        mysql:
            image: mysql:5.7

            environment:
                MYSQL_DATABASE: ${MYSQL_DATABASE}
                MYSQL_USER: ${MYSQL_USER}
                MYSQL_PASSWORD: ${MYSQL_PASSWORD}
                MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}

            volumes:
                - mysql_data:/var/lib/mysql

        volumes:
            mysql_data:


    Verify Environment Variables
        docker compose config

    Observation
        -   Docker Compose successfully reads variables from .env file.

Key Learnings
    - Docker Compose simplifies multi-container deployments.
    - Services automatically communicate through a default network.
    - Named volumes provide persistent storage.
    -.env files help manage configurations securely.
    - Compose improves consistency and reproducibility in development environments.


Repository Structure
2026/
└── day-33/
    ├── day-33-compose.md
    ├── compose-basics/
    │   └── docker-compose.yml
    └── wordpress-mysql/
        ├── docker-compose.yml
        └── .env

Git Commands
    Add Files
        git add .
    Commit Changes
        git commit -m "Day 33 - Docker Compose multi-container setup"
    Push to GitHub
        git push origin main


Conclusion :

    Today I learned how Docker Compose simplifies container orchestration by managing services, networks, and volumes using a single YAML configuration file.

    It makes multi-container application deployment faster, cleaner, and easier to maintain.