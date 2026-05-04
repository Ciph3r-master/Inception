*This project has been created as part of the 42 curriculum by qutruche.*

# Inception

## Description
**Inception** is a System Administration project that aims to deepen knowledge in virtualization and service orchestration. The goal is to build a complex infrastructure consisting of several services (WordPress, MariaDB, and Nginx) using **Docker Compose**.

Every service runs in its own dedicated container, ensuring a modular, scalable, and secure environment. This project emphasizes manual configuration: writing custom Dockerfiles from scratch using **Debian**, avoiding pre-built images from Docker Hub, and managing networking and volumes manually. All source files, including configurations and scripts, are organized within the `srcs/` directory.

### Design Choices
* **Debian (Bullseye/Bookworm):** Selected as the base OS for all containers to ensure maximum stability and consistency with the host environment. It provides a robust and professional-grade foundation for service orchestration.
* **Security-First Nginx:** Configured as the sole entry point (Reverse Proxy) handling TLS v1.2/v1.3 for secure communication.
* **Custom Initialization:** Each service uses a dedicated entrypoint script to handle runtime configurations, such as database setup and user creation.

### Technical Comparisons

| Feature | Option A | Option B | Rationale |
| :--- | :--- | :--- | :--- |
| **Virtual Machines vs Docker** | **VMs** virtualize hardware and include a full Guest OS. | **Docker** virtualizes the OS kernel, sharing it with the host. | Docker is more lightweight, boots faster, and is optimized for microservices. |
| **Secrets vs Env Variables** | **Secrets** are handled as files, keeping sensitive data out of logs. | **Env Variables** are easier to implement but visible in the process tree. | We use Secrets for passwords to prevent accidental exposure in the environment or image layers. |
| **Docker Network vs Host Network** | **Host** shares the host's IP/ports directly, bypassing isolation. | **Docker Network** creates an isolated virtual bridge. | We use a custom Docker Network to isolate services; only Nginx is exposed to the host via port 443. |
| **Docker Volumes vs Bind Mounts** | **Bind Mounts** link a specific host path to the container. | **Docker Volumes** are managed by Docker in a dedicated storage area. | **Volumes** are preferred for data persistence because they are managed entirely by Docker, ensuring better portability and performance. |

## Instructions

### Prerequisites
* Docker and Docker Compose installed.
* `make` utility.
* A Unix-based system (Linux or macOS).

### Installation & Execution
To build and launch the entire infrastructure, run the following command from the root of the repository:

```bash
make
```

**This command will:**

- Create the necessary local data folders for volumes.

- Build the Docker images from the provided Dockerfiles.

- Start all containers in the background.

**For detailed usage, administration access and troubleshooting, please refer to the file [USER_DOC.md ](USER_DOC.md).

## Resources

**Documentation & References**
- [Docker Documentation](https://docs.docker.com/)
- [Docker guide](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/)
- [Nginx Configuration](https://nginx.org/en/docs/beginners_guide.html#conf_structure)
- [MariaDB Documentation](https://mariadb.com/docs/server/)

**Use of AI**

In compliance with the project requirements, AI was utilized during this project for the following tasks:

- **Documentation Drafting:** Assisting in structuring and translating the `README.md`, `DEV_DOC.md` and `USER_DOC.md` into professional English.

- **Troubleshooting:** Explaining Docker permission errors, specifically the "permission denied" issue when connecting to the Docker socket.