*** User Guide ***

**1. System Overview**

This project deploys a fully isolated, three-tier web infrastructure. The ecosystem is composed of three interconnected services:

    NGINX (The Gateway): Acting as the secure front door, this web server intercepts all internet traffic. It encrypts the connection using HTTPS and safely routes visitors to the application.

    WordPress (The Application): This is the user-facing website and content management system. It generates the blog pages and provides a secure backend panel for administrators to publish posts and moderate users.

    MariaDB (The Vault): The backend database engine. It operates completely hidden from the Internet, securely storing all website content, user accounts, and configuration settings.

**2. Launching and Stopping the Infrastructure**

The entire project is controlled using simple commands via the Makefile in the root directory:

    To Deploy: Run make (or make all). This automatically prepares the host folders, builds the system, and boots the containers in the background.

    To Suspend: Run make down. This safely powers off the containers without losing any data.

    To Factory Reset: Run make fclean. Warning: This destroys the containers, cleans the cache, and permanently deletes all saved database and website data.

**3. Accessing the Platform**

Once the deployment is finished, you can interact with the platform using a standard web browser.

    Public Blog: Go to https://hgatarek.42.fr

    Admin Dashboard: Go to https://hgatarek.42.fr/wp-admin (Log in using the Admin credentials to customize the site or approve comments).

    Security Prompt Notice: The system uses a self-signed TLS certificate for local encryption. Your browser may flag the connection as "Not Private." Simply click "Advanced" and choose to proceed safely to the site.

**4. Managing Configurations and Passwords**

To maintain strict security, configuration settings and sensitive passwords are kept completely separate.

    General Settings (.env file): Domain names, site titles, and usernames are defined in the srcs/.env file.

    Passwords (Secrets): All sensitive passwords (database root, database user, WordPress admin) are safely stored as individual text files inside the root secrets/ directory.

    Making Changes: If you wish to change usernames or passwords, you must update these files before running the make command to deploy the infrastructure.

**5. Verifying System Health**

To confirm that the infrastructure is operating correctly, open your terminal and run the following status command:
code Bash

docker ps

You should see an output listing three distinct containers (nginx, wordpress, and mariadb). Verify that the "STATUS" column for all three indicates that they are "Up".