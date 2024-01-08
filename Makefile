build:
	docker compose up --build -d

up:
	docker compose up

down:
	docker compose down 

sh:
	docker exec -ti dbt bash