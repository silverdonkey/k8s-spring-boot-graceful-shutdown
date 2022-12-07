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
ARG USERNAME=nonroot
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN addgroup --gid $USER_GID $USERNAME \
    && adduser --system --no-create-home --gecos "" --uid $USER_UID -S $USERNAME -G $USERNAME \
    && chown -R $USERNAME:$USERNAME /app
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    # && apt-get update \
    # && apt-get install -y sudo \
    # && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    # && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /app

# run application with this command line
#CMD ["/opt/openjdk-18/bin/java", "-jar", "-Dspring.profiles.active=default", "/app/application.jar"]
ENTRYPOINT ["/app/java-run.sh"]
