# Day 31 – Dockerfile: Build Your Own Images

## Objective
Learn how to write Dockerfiles, build custom Docker images, optimize builds, and understand important Docker concepts like CMD, ENTRYPOINT, caching, and `.dockerignore`.

---

# Task 1 – My First Dockerfile

## Create Project Directory

- mkdir my-first-image
- cd my-first-image
- Dockerfile :
    FROM ubuntu

    RUN apt-get update && apt-get install -y curl

    CMD ["echo", "Hello from my custom image!"]

- Build Image
    docker build -t my-ubuntu:v1 .

- Run Container
    docker run my-ubuntu:v1

- Output:
    Hello from my custom image!

# Understanding the Dockerfile
Instruction	Description
    FROM ubuntu	: Uses Ubuntu as the base image
    RUN	Executes : commands during build
    CMD	: Default command executed when container starts


## Task 2 – Dockerfile Instructions

Project Structure
    dockerfile-demo/
    ├── Dockerfile
    ├── app.txt

app.txt
    Dockerfile demo application

- Dockerfile:
    FROM ubuntu

    RUN apt-get update && apt-get install -y curl

    WORKDIR /app

    COPY app.txt /app/

    EXPOSE 8080

    CMD ["cat", "app.txt"]

- Build Image
    docker build -t dockerfile-demo:v1 .

- Run Container
    docker run dockerfile-demo:v1

- Explanation of Instructions
    FROM : Defines the base image.

    FROM ubuntu : Docker starts building the image from Ubuntu.

    RUN : Executes commands during image build.

    RUN apt-get update && apt-get install -y curl

- Used for:
    Installing packages
    Updating repositories
    Configuring software

    WORKDIR : Sets the working directory inside the container.

    WORKDIR /app : Equivalent to using cd /app.

    COPY : Copies files from local system to container.

    COPY app.txt /app/
    
    EXPOSE : Documents which port the application uses.

    EXPOSE 8080 :Does not publish the port automatically.

    CMD :Defines the default command for the container.

    CMD ["cat", "app.txt"] :Runs when container starts.


## Task 3 – CMD vs ENTRYPOINT

CMD Example

Dockerfile :
    FROM ubuntu

    CMD ["echo", "hello"]

Build
    docker build -t cmd-demo .

Run
    docker run cmd-demo

Output
    hello

Override CMD :
    docker run cmd-demo ls

The default command gets replaced by ls.

ENTRYPOINT Example
Dockerfile :
    FROM ubuntu

    ENTRYPOINT ["echo"]

Build
    docker build -t entrypoint-demo .

Run
    docker run entrypoint-demo hello

Output :
    hello

Additional Arguments
    docker run entrypoint-demo Docker is awesome

Output :
    Docker is awesome

CMD vs ENTRYPOINT
CMD	ENTRYPOINT
Default command	Main executable
Can be overridden	Usually fixed
Flexible	More strict
When to Use CMD

Use CMD when:
    Users may run different commands
    You want flexibility
    When to Use ENTRYPOINT

Use ENTRYPOINT when:
    Container should always run the same executable
    Building utility-style containers


## Task 4 – Build a Simple Web App Image

index.html
    <!DOCTYPE html>
    <html>
        <head>
            <title>Docker Website</title>
        </head>
        <body>
            <h1>Hello from Docker Nginx!</h1>
        </body>
    </html>

Dockerfile
    FROM nginx:alpine

    COPY index.html /usr/share/nginx/html/

- Build Image
    docker build -t my-website:v1 .

- Run Container
    docker run -d -p 8080:80 my-website:v1

- Access Website
    Open browser : http://localhost:8080



## Task 5 – .dockerignore

- What is .dockerignore?
    .dockerignore prevents unnecessary files from being sent to the Docker build context.


- .dockerignore File :
node_modules
    .git
    *.md
    .env

- Why Use .dockerignore?
1. Reduces Image Size
Large folders like node_modules are excluded.

Result:
Smaller images
Less storage usage

2. Speeds Up Build Process
Docker sends fewer files during build.

Result:
Faster builds
Faster uploads to Docker daemon

3. Prevents Sensitive Files from Entering Images
Files like .env may contain:
    API keys
    Passwords
    Tokens

Ignoring them improves security.


4. Improves Docker Cache Efficiency
Docker builds images layer by layer.

If unnecessary files change:
    Docker invalidates cache
    Layers rebuild again

Using .dockerignore avoids unnecessary rebuilds.

Where to Place .dockerignore?

Place .dockerignore in the root directory of the build context.

Example:

project/
├── Dockerfile
├── .dockerignore
├── app.js
└── package.json

Docker automatically reads it during:

docker build .



## Task 6 – Build Optimization

- Initial Dockerfile
    FROM ubuntu

    COPY . /app

    RUN apt-get update && apt-get install -y curl

- Problem:
    If any file changes, Docker rebuilds everything again.

- Optimized Dockerfile
    FROM ubuntu

    RUN apt-get update && apt-get install -y curl

    COPY . /app

- Now Docker reuses cached package installation layers.

Why Layer Order Matters

Docker creates image layers for each instruction.

- Best Practice:
    Stable instructions → top
    Frequently changing code → bottom

Benefits:

    Faster rebuilds
    Better caching
    Improved CI/CD performance
    Important Docker Commands

- Build Image
    docker build -t image-name:tag .
- Run Container
    docker run image-name
- Run with Port Mapping
    docker run -d -p 8080:80 image-name
- List Images
    docker images
- Running Containers
    docker ps
- Stop Container
    docker stop <container-id>


Key Learnings :

Today I learned:
    How to create Dockerfiles
    How to build custom Docker images
    Difference between CMD and ENTRYPOINT
    How Nginx serves static websites
    Importance of .dockerignore
    Docker layer caching and optimization
    Why Dockerfile order matters

This hands-on practice improved my understanding of how real-world applications are packaged and deployed using Docker.