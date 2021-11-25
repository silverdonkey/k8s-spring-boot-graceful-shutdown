# Conainerized Spring Boot app - graceful shutdown Demo 
This is a simple project which demonstrates the pitfalls with the graceful shutdown configuration in a Spring Boot microservice deployt as Docker container. 
- Alpine Linux with JRE-8
- Spring Boot 2.3.4
- InteliJ
- Using a [shell as pre-start hook](java-run.sh) to start the spring-boot app. The [exec](https://en.wikipedia.org/wiki/Exec_(system_call)) is very important there!

# Build Docker Image and run it

- "docker build -t spring-boot-app-8-jre-alpine:1.0.0 ."
- "docker image ls"
- "docker run -d -p 8080:8080 spring-boot-app-8-jre-alpine:1.0.0"
- "docker ps -a"
- Go to your Browser and open http://localhost:8080/entity/all
- "docker logs < container-id >"
- "docker stop < container-id >"





