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
	# WORDPRESS_THEME:  #
	# Define your theme #
	# Example:          #
	#  - prespa-saas    #
	#  - hello-biz      #
	#  - variations     #
	#  - saaslauncher   #
	#####################

	WORDPRESS_THEME=prespa-saas
	```

2.  **Secrets Directory:** Create a `./secrets/` directory (refer to the `srcs` structure). This folder must contain the following plain-text files:
    * `mariadb/mariadb_wp_user_password.txt`: Password for the MariaDB WordPress user.
    * `wordpress/wp_admin_mail.txt`: Mail for the WordPress admin user.
    * `wordpress/wp_admin_name.txt`: Username for the WordPress admin user.
    * `wordpress/wp_admin_password.txt`: Password for the WordPress admin user.
    * `wordpress/wp_user_mail.txt`: Mail for the WordPress default author.
    * `wordpress/wp_user_name.txt`: Username for the WordPress default author.
    * `wordpress/wp_user_password.txt`: Password for the WordPress default author.

## 2. Building and Launching

The project is automated via a `Makefile` located at the root of the repository.
