FROM openjdk:18-jdk-alpine

RUN apk add --no-cache bash

RUN mkdir -p /app
COPY java-run.sh /app
RUN chmod +x /app/java-run.sh

# Add our service
COPY target/*.jar /app/application.jar

WORKDIR /app

# run application with this command line
#CMD ["/usr/bin/java", "-jar", "-Dspring.profiles.active=default", "/app/application.jar"]
ENTRYPOINT ["/app/java-run.sh"]
