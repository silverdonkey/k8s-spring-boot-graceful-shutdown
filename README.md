# Conainerized Spring Boot app - graceful shutdown Demo 
This is a simple project which demonstrates the pitfalls with the graceful shutdown configuration in a Spring Boot microservice deployt as Docker container. 
- Alpine Linux with JRE-8
- Spring Boot 2.3.4
- InteliJ
- Using a [shell as pre-start hook](java-run.sh) to start the spring-boot app. The [exec](https://en.wikipedia.org/wiki/Exec_(system_call)) portion of the bash command is important because it replaces the bash process with your server, so that the shell only exists momentarily at start!
- Use "docker stop < container-id >" to send SIGTERM signal to the container
- Look at the logs and watch for "[extShutdownHook] o.s.b.w.e.tomcat.GracefulShutdown        : Commencing graceful shutdown. Waiting for active requests to complete" 
- Check the exist status of the containers ('Exiited (143)' means 'gracefully terminated' while 'Exited (137)' means 'killed')
- For more information check [sigterm and exit codes](https://komodor.com/learn/sigterm-signal-15-exit-code-143-linux-graceful-termination/)

# Build Docker Image and run it

Build both images
- "docker build -t k8s-spring-boot-app-graceful:1.0.0 ."
- "docker build -t k8s-spring-boot-app-non-graceful:1.0.0 . -f Dockerfile-non-graceful"
- "docker image ls"

Do these steps with both containers
- "docker run -d -p 8080:8080 k8s-spring-boot-app-graceful:1.0.0"
- "docker ps -a"
- Go to your Browser and open http://localhost:8080/entity/all
- "docker logs < container-id >"
- "docker stop < container-id >"





