# Developer Guide 

### 1. Environment Preparation

System Requirements:
You must have Docker Engine and Docker Compose (v2) installed on your system.

Local DNS Routing:
To access the application via the browser, you need to route the project's domain name to your local machine. Open your /etc/hosts file and append the following line:

```text
127.0.0.1   hgatarek.42.fr
```

Configuration Files:
Before building the project, ensure you have created and configured your .env file (using an .env.example template) and generated the necessary password .txt files inside the secrets/ directory.

### 2. Infrastructure Deployment

The entire lifecycle of the containers is automated through the Makefile located in the root directory.

    make all (or make): Initializes the required data directories on the host machine, compiles the Dockerfiles, and spins up the container architecture in detached mode.

    make down: Gracefully halts the services and removes the Docker network without touching your persistent data.

    make fclean: Performs a hard reset. This command stops all services, prunes the Docker cache, and permanently wipes the physical data folders from the host machine.

### 3. Useful CLI Commands

Once the project is running, you can manage and debug the infrastructure using standard Docker commands:

    Check active services: docker ps

    Monitor terminal output: docker logs -f <service_name> (e.g., mariadb or wordpress)

    Open an interactive shell: docker exec -it <container_name> bash (Type exit to leave the shell)

    Check existing volumes: docker volume ls

### 4. Persistent Storage Architecture

Docker containers are ephemeral by nature, meaning any data stored inside them is lost when the container is deleted. To achieve true data persistence, this project utilizes Docker Named Volumes configured with local driver options to bind directly to the host's hard drive:

    Database Storage: The MariaDB container directory (/var/lib/mysql) is bound to the host at /home/hgatarek/data/mariadb.

    Web Application Storage: The WordPress container directory (/var/www/html) is bound to the host at /home/hgatarek/data/wordpress.

Persistence Guarantee: As long as the host directories are untouched, your website themes, users, and database entries will survive container crashes, manual removals, or virtual machine reboots. Data is only wiped if you explicitly delete the host folders (e.g., via make fclean).