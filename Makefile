build:
	docker build -t gocd-server .

run:
	docker run -d --name gocd-server -p 8153:8153 -p 8154:8154 gocd-server

clean:
	docker rm -f gocd-server