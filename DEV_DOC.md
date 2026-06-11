# Developer Documentation

This document is intended for developers who wish to set up the development environment, modify the stack, or troubleshoot the infrastructure.

## 1. Environment Setup

### Prerequisites
Before starting, ensure your host system (Debian) has the following tools installed:
* **Docker Engine** (latest version)
* **Docker Compose**
* **GNU Make**
* **Git**

### Configuration & Secrets
The project relies on environment variables and secret files that are **not** committed to the repository for security reasons.

1. Environment Variables
Create a `.env` file in the `srcs/` directory. This file defines the metadata and non-sensitive configurations for the stack.

	| Variable | Description | Example |
	| :--- | :--- | :--- |
	| **DOMAIN_NAME** | The URL used for Nginx routing and WP redirections | `login.42.fr` |
	| **MARIADB_WORDPRESS_DB** | The name of the WordPress database | `wp_db` |
	| **MARIADB_WP_USER** | The database username | `wp_user` |
	| **WORDPRESS_TITLE** | The public title of your website | `Inception` |
	| **WORDPRESS_THEME** | The slug of the theme to install | `prespa-saas` |
	| **FTP_USER** | The username used to authenticate and connect to the secure FTP server | `ftp_user` |

	**Example:**

	```
	DOMAIN_NAME=login.42.fr

	#############
	#  MARIADB  #
	#############

	# WORDPRESS DATABASE
	MARIADB_WORDPRESS_DB=wp_db

	# MYSQL WORDPRESS USER
	MARIADB_WP_USER=wp_user

	#############
	# WORDPRESS #
	#############

	WORDPRESS_TITLE="Inception"


	#####################
	#    FTP SERVICE    #
	#####################

	# FTP USER WHO ACCESS TO WORDPRESS FILES
	FTP_USER=ftp_wordpress

	```

2.  **Secrets Directory:** Create a `./secrets/` directory (refer to the `srcs` structure). This folder must contain the following plain-text files:
    * `mariadb/mariadb_wp_user_password.txt`: Password for the MariaDB WordPress user.
    * `ftp/ftp_password.txt`: Password for the ftp user.
    * `wordpress/wp_admin_mail.txt`: Mail for the WordPress admin user.
    * `wordpress/wp_admin_name.txt`: Username for the WordPress admin user.
    * `wordpress/wp_admin_password.txt`: Password for the WordPress admin user.
    * `wordpress/wp_user_mail.txt`: Mail for the WordPress default author.
    * `wordpress/wp_user_name.txt`: Username for the WordPress default author.
    * `wordpress/wp_user_password.txt`: Password for the WordPress default author.

## 2. Building and Launching

The project is automated via a `Makefile` located at the root of the repository.

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

## 3. Checking Service Status
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

To view logs for a specific service u can use the **service name**

```bash
docker compose -f ./srcs/docker-compose.yml logs -f <service_name>
```

or

```bash
make logs
```

### Managing Volumes:

Data is persisted inside Docker volumes. To list all active volumes on your system:

```bash
docker volume ls
```

To inspect the low-level technical configuration and host mountpath of a specific volume:

```bash
docker volume inspect <volume_name>
```

If you have stopped your containers and want to safely remove any unused/orphaned local volumes to free up space:

```bash
docker volume prune
```

(Remember that `make fclean` will automatically handle a full local data and system wipe safely).

### How Volume Data and Persistence Work
The project's persistence relies entirely on local Docker bind-mounted volumes defined explicitly within your `docker-compose.yml` file:

* **Storage Location on Host:** Data is mapped directly to absolute paths on the host machine via the `volumes` configuration block:

    * **Database (MariaDB):** Bound via the `db_data` volume to the physical host directory.

    * **Web Application (WordPress):** Bound via the `wp_data` volume to the physical host directory.

* **Shared Storage Mechanism:** The `wp_data` volume is cross-mounted and shared simultaneously between the **Web Application** and the **FTP Server** containers. This design ensures that any file uploaded or updated via FTP instantly reflects in the live web app environment and remains safe even if the containers are destroyed.

* **Persistence Safeguards:** Standard restarts or execution of `make stop` will tear down containers but keep your underlying data completely safe. Your data will only be permanently destroyed when explicitly triggering a deep wipe via `make fclean`.