.PHONY: all stop fclean re ps

SRCS = srcs

COMPOSE_FILE = $(SRCS)/docker-compose.yml

all:
	docker compose -f $(COMPOSE_FILE) up -d --build

stop:
	docker compose -f $(COMPOSE_FILE) down -v

fclean: stop
	docker system prune -a -f

re: fclean all

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) ps