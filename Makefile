.PHONY: all stop fclean re ps create_secrets_files help logs
 
SRCS = srcs

COMPOSE_FILE = $(SRCS)/docker-compose.yml

HOME_VOLUME = /home/qutruche

DATA_VOLUME = $(HOME_VOLUME)/data

all:
	docker compose -f $(COMPOSE_FILE) up -d --build

help:
	@echo "Usage: make [target]";
	@echo "Targets:"
	@echo "  all                    Build and start the Docker containers";
	@echo "  stop                   Stop and remove the Docker containers / volumes";
	@echo "  fclean                 Stop and remove the Docker containers / volumes, and prune the system";
	@echo "  re                     fclean and make all";
	@echo "  create_secrets_files   Create the secrets files for WordPress and MariaDB";
	@echo "  logs                   Follow the logs of the Docker containers";
	@echo "  ps                     List the running Docker containers";

stop:
	docker compose -f $(COMPOSE_FILE) down -v

fclean: stop
	docker system prune -a -f
	sudo rm -rf $(DATA_VOLUME)
	sudo mkdir -p $(DATA_VOLUME)
	sudo mkdir -p $(DATA_VOLUME)/wordpress
	sudo mkdir -p $(DATA_VOLUME)/mariadb
	sudo chown -R qutruche:qutruche $(HOME_VOLUME)

re: fclean all

create_secrets_files:
	mkdir -p ./secrets/
	mkdir -p ./secrets/wordpress
	mkdir -p ./secrets/mariadb
	mkdir -p ./secrets/ftp
	touch ./secrets/wordpress/wp_admin_mail.txt
	touch ./secrets/wordpress/wp_admin_name.txt
	touch ./secrets/wordpress/wp_admin_password.txt
	touch ./secrets/wordpress/wp_user_mail.txt
	touch ./secrets/wordpress/wp_user_name.txt
	touch ./secrets/wordpress/wp_user_password.txt
	touch ./secrets/mariadb/mariadb_wp_user_password.txt
	touch ./secrets/ftp/ftp_password.txt

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) ps -a