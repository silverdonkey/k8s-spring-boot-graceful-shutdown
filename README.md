# Containerized Spring Boot app - graceful shutdown Demo 
This is a simple project which demonstrates the pitfalls with the graceful shutdown configuration in a Spring Boot microservice deployt as Docker container. 
- Alpine Linux with JDK-18
- Spring Boot 2.7.4
- InteliJ
- Using a [shell as pre-start hook](java-run.sh) to start the spring-boot app. The [exec](https://en.wikipedia.org/wiki/Exec_(system_call)) portion of the bash command is important because it replaces the bash process with your server, so that the shell only exists momentarily at start!
- Use "docker stop < container-id >" to send SIGTERM signal to the container
- Look at the logs and watch for "[extShutdownHook] o.s.b.w.e.tomcat.GracefulShutdown        : Commencing graceful shutdown. Waiting for active requests to complete" 
- Check the exited status of the containers ('Exited (143)' means 'gracefully terminated' while 'Exited (137)' means 'killed')
- For more information check [sigterm and exit codes](https://komodor.com/learn/sigterm-signal-15-exit-code-143-linux-graceful-termination/)

# Notes about the Demo
- Spring-Boot-Service: the Endpoint /entity/all simulates a slow response (5s)
- Demo impl with using a static Linux lib 'dumb-init' as a Docker Entrypoint: for more information go to [dumb-init for docker](https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html) or check [dumb-init on GitHub](https://github.com/Yelp/dumb-init)

# Build Docker Image and Run It

Build both images
- "docker build -t k8s-spring-boot-app-graceful:1.0.0 ."
- "docker build -t k8s-spring-boot-app-non-graceful:1.0.0 . -f Dockerfile-non-graceful"
- "docker build -t k8s-spring-boot-app-graceful-dumb-init:1.0.0 . -f Dockerfile-graceful-dumb-init"
- "docker image ls"

Do these steps with both containers
- "docker run -d -p 8080:8080 k8s-spring-boot-app-graceful:1.0.0"
- "docker ps -a"
- Go to your Browser and open http://localhost:8080/entity/all
- "docker logs < container-id >"
- "docker stop < container-id >"

When finished with the demo: 
- "docker system prune"
- "docker image prune -a"





