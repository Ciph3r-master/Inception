# User Documentation

This guide provides the necessary information to manage, access, and monitor the project stack.

## 1. Services Provided
The stack is composed of several integrated services to ensure a complete functional environment:
* **Web Application:** The main user-facing interface.
* **Static Web Server:** A lightweight, high-performance server powered by **BusyBox httpd** to serve static assets and websites (HTML, CSS, JS) with minimal footprint.
* **Administration Panel:** A back-office tool for managing data and configurations.
* **Database:** A persistent storage system for all application data.
* **FTP Server:** A secure file transfer server directly linked to the *Web Application* volume, allowing seamless file uploads and management.
* **Redis Cache:** An in-memory data structure store used as a caching layer to boost performance and reduce database load.
* **Adminer:** A lightweight, web-based database management tool to easily administer the Database via a browser.
* **cAdvisor (Monitoring):** A real-time resource usage and performance monitoring tool that collects, aggregates, and exports metrics (CPU, memory, network, and disk usage) from the host machine and running containers.
* **Reverse Proxy:** Handles routing, security, and SSL termination.

## 2. Managing the Project
The project is containerized for easy management. You can control the entire stack using the following commands:

### Starting the services
To start all services in the background, run:
```bash
docker compose -f ./srcs/docker-compose.yml up -d --build
```

or

```bash
make
```

> **Note**: The `-d` flag runs containers in the background and `--build` ensures images are updated before starting.

### Stopping the services
To stop all services in the background, run:
```bash
docker compose -f ./srcs/docker-compose.yml down -v
```

or

```bash
make stop
```

> **Warning:** The -v flag removes all volumes. Use it only if you want to reset your database and persistent data.

### Deep clean the services

If you need to completely wipe the environment (including Docker system cache and local persistent data directories), use the following Makefile target:

```bash
make fclean
```

> **Warning:** This will trigger a docker system prune -a -f, delete all local data volumes (including your dynamic application and database persistent storage), and recreate empty directories with the proper permissions.


### Rebuild from Scratch

To perform a complete wipe and immediately restart the entire stack fresh:

```bash
make re
```

## 3. Accessing the Platform
Once the services are running, you can access the different parts of the application via your browser.

Note that the project uses a self-signed certificate, so you may need to bypass the browser security warning.

- **Main Website:** https://DOMAINNAME/ (Replace domain name by the .env var)
- **Administration Panel:** https://DOMAINNAME/wp-admin

## 4. Credentials & Security
For security reasons, sensitive information is never hardcoded into the application

**Locating Credentials**

All environment-specific variables are stored securely in the `.env` file or within individual files in the `./secrets/` directory.

**Secret files (`./secrets/`):**

- **WordPress Database:** Database user password
- **WordPress Admin:** Name, email and password
- **Default WordPress User:** Name, email and password
- **WordPress FTP:** FTP password

**Env file (`.env`):**

- **WordPress:** Website Title
- **MariaDB:** WordPress database name, and WordPress database user
- **FTP:** FTP user name
- **Other:** Domain name for redirections in wordpress and nginx


> `Important:` Do not share or commit this files to public repositories.
Ensure they are listed in your `.gitignore`.

## 5. Checking Service Status
To ensure that all services are running correctly, you can perform the following checks:

**Container Status**
Run the following command to see the status of all active components:

```bash
docker compose -f ./srcs/docker-compose.yml ps
```

or

```bash
make ps
```

Ensure that all services show a status of `Up` or `Healthy`

**Logs & Troubleshooting**
If you encounter any issues, you can inspect the real-time logs of the containers:

```bash
docker compose -f ./srcs/docker-compose.yml logs -f
```

or

```bash
make logs
```