boot:
	sudo docker run --name postgresql --network localdev -d -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres
	
rm:
	sudo docker rm postgres

start:
	sudo docker start postgres

stop:
	sudo docker stop postgres
