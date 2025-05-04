Files:
	requirements.txt
	app.py
	Dockerfile
	docker-compose.yml

Build command:
	docker-compose build	

Run command:
	docker-compose up -d

Check ports:
	docker exec -it  ComposeExample1_app_1  netstat -atn
	docker exec -it  ComposeExample1_redis_1  netstat -atn

Client Commands:
	Add a student:
		curl --header "Content-Type: application/json" \
			--request POST --data '{"name":"Rossi"}' localhost:8080

	Lists students:
		curl localhost:8080

Stop and remove containers, networks and volume created by "up":
	docker-compose down	

Stop and remove containers, networks, volume and images created by "up":
	docker-compose down --rmi all

