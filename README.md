# Build Docker Image and run it

- "docker build -t spring-boot-app-8-jre-alpine:1.0.0 ."
- "docker image ls"
- "docker run -d -p 8080:8080 spring-boot-app-8-jre-alpine:1.0.0"
- "docker ps -a"
- "docker logs <container-id>"
- "docker stop <container-id>"

Go to your Browser and open http://localhost:8080/entity/all



