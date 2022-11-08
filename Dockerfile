FROM openjdk:18-jdk-alpine

RUN apk add --no-cache bash

RUN mkdir -p /app
COPY java-run.sh /app
RUN chmod +x /app/java-run.sh

# Add our service
COPY target/*.jar /app/application.jar

# Add a NON-root user to run the app
RUN addgroup -S nonroot && adduser --disabled-password --system --uid 1000 --home /app --gecos "" -S nonroot -G nonroot && chown -R nonroot:nonroot /app

USER nonroot
WORKDIR /app

# run application with this command line
#CMD ["/opt/openjdk-18/bin/java", "-jar", "-Dspring.profiles.active=default", "/app/application.jar"]
ENTRYPOINT ["/app/java-run.sh"]
