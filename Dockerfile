FROM openjdk:18-jdk-alpine

RUN apk add --no-cache bash

RUN mkdir -p /app
COPY java-run.sh /app
RUN chmod +x /app/java-run.sh

# Add our service
COPY target/*.jar /app/application.jar

# Add a NON-root system user to run the app
# By default, system users are placed in the nogroup group.
# The new system user will have the shell /bin/false (no shell)
# and have logins disabled.
# --shell /bin/false
# --disabled-login
RUN adduser --system --no-create-home --gecos "" --uid 1000 -S nonroot \
    && chown -R nonroot /app

USER nonroot
WORKDIR /app

# run application with this command line
#CMD ["/opt/openjdk-18/bin/java", "-jar", "-Dspring.profiles.active=default", "/app/application.jar"]
ENTRYPOINT ["/app/java-run.sh"]
