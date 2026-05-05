.PHONY: all stop fclean re ps create_secrets_files

SRCS = srcs

COMPOSE_FILE = $(SRCS)/docker-compose.yml

all:
	docker compose -f $(COMPOSE_FILE) up -d --build

stop:
	docker compose -f $(COMPOSE_FILE) down -v

fclean: stop
	docker system prune -a -f

re: fclean all

create_secrets_files:
	mkdir -p ./secrets/
	mkdir -p ./secrets/wordpress
	mkdir -p ./secrets/mariadb
	touch ./secrets/wordpress/wp_admin_mail.txt
	touch ./secrets/wordpress/wp_admin_name.txt
	touch ./secrets/wordpress/wp_admin_password.txt
	touch ./secrets/wordpress/wp_user_mail.txt
	touch ./secrets/wordpress/wp_user_name.txt
	touch ./secrets/wordpress/wp_user_password.txt
	touch ./secrets/mariadb/mariadb_wp_user_password.txt

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) ps