LOGIN = hgatarek
DATA_PATH = /home/$(LOGIN)/data

all:
	mkdir -p /home/login/data/mariadb 
	mkdir -p /home/login/data/wordpress
	docker-compose -f src/docker-compose.yaml up --build

down:
	docker-compose -f ./src/docker-compose.yml down

clean:
	docker-compose -f ./src/docker-compose.yml down -v
	docker system prune -af

fclean: clean
	@sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all down clean fclean re