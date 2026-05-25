LOGIN = hgatarek
DATA_PATH = /home/$(LOGIN)/data
COMPOSE_FILE = ./srcs/docker-compose.yaml

all:
	mkdir -p ${DATA_PATH}/mariadb
	mkdir -p ${DATA_PATH}/wordpress
	docker compose -f ${COMPOSE_FILE} up -d --build

down:
	docker compose -f ${COMPOSE_FILE} down

clean:
	docker compose -f ${COMPOSE_FILE} down -v
	docker system prune -af

fclean: clean
	@sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all down clean fclean re