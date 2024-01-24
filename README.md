# Containerized Spring Boot App - graceful shutdown Demo 
This is a simple project which demonstrates the pitfalls with the graceful shutdown configuration in a Spring Boot microservice deployed as Docker container. 
- Amazon Corretto Alpine-based Linux with JDK-21
- Spring Boot 3.2.2
- Apache Maven 3.9.6
- OpenJDK 21.0.1
- Using a [shell as pre-start hook](java-run.sh) to start the spring-boot app. The [exec](https://en.wikipedia.org/wiki/Exec_(system_call)) portion of the bash command is important because it replaces the bash process with your server, so that the shell only exists momentarily at start!

# About Web Server Graceful Shutdown Feature in Spring Boot
As of [Spring Boot 2.3](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.3-Release-Notes#graceful-shutdown), 
Spring Boot now supports the graceful shutdown feature for all four embedded web servers (Tomcat, Jetty, Undertow, and Netty) 
on both servlet and reactive platforms.

To enable the graceful shutdown, all we have to do is to set the server.shutdown property to graceful in our application.properties file:

        server.shutdown=graceful

Then, Tomcat, Netty, and Jetty will stop accepting new requests at the network layer. Undertow, however, will continue to accept new requests 
but send an immediate 503 Service Unavailable response to the clients.

By default, the value of this property is equal to immediate: the server gets shut down immediately.

Some requests might get accepted just before the graceful shutdown phase begins. In that case, the server will wait for all active 
requests to finish their work up to a specified amount of time. We can configure this grace period using the 
spring.lifecycle.timeout-per-shutdown-phase configuration property (The default value is 30 seconds.):

        spring.lifecycle.timeout-per-shutdown-phase=21s


# Notes about the Demo
- Spring-Boot-Service: the Endpoint /entity/all simulates a slow response (5s)
- Demo impl with using a static Linux lib 'dumb-init' as a Docker Entrypoint: for more information go to [dumb-init for docker](https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html) or check [dumb-init on GitHub](https://github.com/Yelp/dumb-init)
- Use "docker stop < container-id >" to send SIGTERM signal to the container
- Look at the logs and watch for "[extShutdownHook] o.s.b.w.e.tomcat.GracefulShutdown        : Commencing graceful shutdown. Waiting for active requests to complete"
- Check the exited status of the containers ('Exited (143)' means 'gracefully terminated' while 'Exited (137)' means 'killed')
- For more information check [sigterm and exit codes](https://komodor.com/learn/sigterm-signal-15-exit-code-143-linux-graceful-termination/)

# Build and Run the App Locally
Build the App with Maven:

    mvn clean verify

Start the App with Maven from the Terminal:

    mvn spring-boot:run

Open your Browser and navigate to:

    http://localhost:8080/entity/all

# Build and Run the App within Docker Container

## Build Docker Images on x86_64/amd64 (Intel 64-bit)
Run the Docker build command and tag the images

    docker build -t k8s-spring-boot-app-graceful:1.0.0 . -f Dockerfile
    docker build -t k8s-spring-boot-app-non-graceful:1.0.0 . -f Dockerfile-non-graceful
    docker build -t k8s-spring-boot-app-graceful-dumb-init:1.0.0 . -f Dockerfile-graceful-dumb-init
    docker image ls

## Run Containers on x86_64/amd64 (Intel 64-bit)


    docker run -d -p 8080:8080 k8s-spring-boot-app-graceful:1.0.0

To start the container securely pass these params **--read-only --tmpfs /tmp**
Optional (if in Dockerfile not set) pass the current user: "--user $(id -u):$(id -g)"

    docker run -d -p 8080:8080 --read-only --tmpfs /tmp k8s-spring-boot-app-graceful:1.0.0

Go to your Browser and open 

    http://localhost:8080/entity/all

Check the status and logs of the running container

    docker ps -a
    docker logs <container-id>

Stop the container

    docker stop <container-id>

Check the status of the stopped container

    docker ps -a


## Build images on arm64 (Apple Silicon 64-bit)
Add '--platform linux/amd64' flag to the 'build' command:

    docker build --platform linux/amd64 -t k8s-spring-boot-app-graceful:1.0.0 . -f Dockerfile 
    docker build --platform linux/amd64 -t k8s-spring-boot-app-non-graceful:1.0.0 . -f Dockerfile-non-graceful
    docker build --platform linux/amd64 -t k8s-spring-boot-app-graceful-dumb-init:1.0.0 . -f Dockerfile-graceful-dumb-init
    docker image ls

## Run containers on arm64 (Apple Silicon 64-bit)
Add '--platform linux/amd64' flag to the run command:

    docker run --platform linux/amd64 -d -p 8080:8080 k8s-spring-boot-app-graceful:1.0.0

To start the container securely pass these params **--read-only --tmpfs /tmp**
Optional (if in Dockerfile not set) pass the current user: "--user $(id -u):$(id -g)"

    docker run --platform linux/amd64 -d -p 8080:8080 --read-only --tmpfs /tmp k8s-spring-boot-app-graceful:1.0.0



When finished with the demo: 

    docker system prune
    docker image prune -a





