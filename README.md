*This project has been created as part of the 42 curriculum by hgatarek*

# Inception

### Description
This project covered setting up small Docker infrastracture with docker-compose, introducing me to the world of containerization. Objective and intentional complexity was to build layers of images manually with DockerCLI and to start up nginx (as reverse proxy), Wordpress and MariaDB services from scratch using pure Bash scripts and SQL injection. 

Handy syllabus:
	- Virtual Machines vs Docker
		**Virtual Machines** are the substitutes of real physical computers, working as a detached, isolated environment. They host heavy operating systems, stacked with components and full array of features. They utilize hardware-level virtualization. A program called a Hypervisor allocates physical hardware (RAM, CPU). Because each VM must boot its own complete, heavy Guest Operating System, they are resource-intensive and slow to start.
		**Docker**, while still assuring the isolation, was invented to introduce containerisation with services of the user's choice with fast building time, giving 100% reproducibility and compliance for developing projects, regardless of system the developer is working on. Docker uses host machine kernel which makes it lightweight and handy tool for quick deployments.
	
	- Secrets vs Environment Variables
		**Secrets** are the secure solution for sensitive credentials. Instead of being injected into the system environment, Secrets are mounted directly into a temporary, in-memory filesystem (RAM/tmpfs) inside the container (e.g., /run/secrets/). They are never written to the container's hard drive and cannot be seen via docker inspect, ensuring that passwords remain completely hidden and secure.
		**Environemnt Variables** are set of variables that are exported to the operating system for usage (general settings), adding extra layer of scalability and flexibility - developer doesn't need to change env everywhere in the project, they are expanded with $. They are fundamentally insecure for passwords, as anyone running docker inspect or viewing a PHP crash dump can read them in plain text.
	
	- Docker Network vs Host Network
		**Docker Network** is isolated, user-defined communication environment created by docker-compose.yaml for containers to communicate to each other using their service names, without exposing database to the host. Without network, they don't see each other. They also can communicate with outside network if the port is opened.
		Host Network
		**Host Network** takes away the isolation. Container shares the host machine's IP.
	
	- Docker Volumes vs Bind Mounts
		In Docker, data inside a container is ephemeral (it disappears when the container is deleted). To keep your files safe, you must use one of these two storage mechanisms.
		**Docker Volumes** are directories on host hard drive designated to hold the data which belongs to container - they are mutually mapped. They are completely managed by Docker Engine and assure persisting the data even after switching off the containers.
		**Bind Mounts** link a specific path on your host machine directly to a path in the container. From Volumes it differs in a way that the data belongs to the host. If you edit a file on your computer, it changes instantly inside the container


### Instructions

1. Host Network Configuration

Before launching the infrastructure, you must configure your local machine to route your 42 domain name to the local loopback address.

Open your hosts file:

```bash
sudo nano /etc/hosts
```

Add the following line to the top of the file (replace login with your actual name):

```text
127.0.0.1   login.42.fr
``` 

2. Environment Variables & Secrets Setup

For security reasons, .env files and passwords are not pushed to this Git repository. You must manually create them before compilation.

A. Create the .env file:
Create a file named .env inside the srcs/ directory and populate it with your non-secret variables:

```bash
# srcs/.env
DOMAIN_NAME=login.42.fr
WP_TITLE=Inception_Site
WP_ADMIN_USER=your_admin_username
WP_ADMIN_EMAIL=admin@login.42.fr
WP_USER=your_normal_username
WP_USER_EMAIL=user@login.42.fr
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
```

B. Create the Secrets:
Create a folder named secrets/ at the root of the repository and generate your password files. You can do this quickly via the terminal:
code Bash

```bash
mkdir -p secrets
echo "your_db_password" > secrets/db_password.txt
echo "your_db_root_password" > secrets/db_root_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password" > secrets/wp_user_password.txt
```

3. Compilation and Execution

A Makefile is provided at the root of the repository to fully automate the build, configuration, and deployment process using docker compose.

To create the persistent volume directories on your host machine, build the Docker images from scratch, and launch the containers in detached mode, run:

```bash
make all
``` 

4. Accessing the Application

Once the containers are running and initialized, open your web browser and navigate to:
https://login.42.fr

    Note: Because the NGINX container generates and uses a local, self-signed SSL/TLS certificate during the build process, your browser will display a security warning (e.g., "Potential Security Risk"). Click Advanced -> Accept the Risk and Continue to access the website.

To access the WordPress Administrator Dashboard to manage the site or approve comments, navigate to:
https://login.42.fr/wp-admin

5. Container Management & Cleanup

You can manage the lifecycle of the infrastructure using the provided Makefile rules:

    make down: Safely stops all running containers and removes the Docker network, but preserves your database and WordPress files on the host machine.

    make clean: Stops the containers and removes the Docker volumes, wiping the internal container data.

    make fclean: Performs a complete deep clean. It executes make clean, prunes the Docker system cache, and permanently deletes the physical volume folders from the host machine (/home/login/data/). Use this for a completely fresh start.

### Resources

https://nginx.org/en/docs/

https://docs.docker.com/engine/

https://docs.docker.com/get-started/docker-overview/

https://mariadb.com/docs/


https://apxml.com/courses/docker-for-ml-projects/chapter-3-managing-ml-data-containers/bind-mounts-vs-volumes

### AI Usage
	Throughout the Inception project, I utilized AI (LLMs) as an interactive debugging assistant and a tool to deepen my understanding of system administration concepts. Specifically, I used AI to help structure my Bash entrypoint.sh scripts and to troubleshoot complex container communication issues.
	I used AI to analyse my container logs. It helped me to investigate and debug the problem with connecting Wordpress to MariaDB. Turned out I didn't include working directory for wordpress in Dockerfile and my database didn't see any of them. 
	Because of this missing line, WordPress was downloading to the wrong root directory, leaving the shared volume empty for NGINX. In browser it kept returning 403 Forbidden error since there was nothing to show from Wordpress site. 
	AI was also harnessed to help me sum up my knowledge and write dev_ and user_ docs.