#!/bin/bash

echo "Running as User: $(whoami)"
echo "Using a shell as a pre-start hook."
echo "You can run scripts before starting your java app... (e.g. import SSL certificates)"
echo "JAVA_HOME=$JAVA_HOME"
echo "JAVA_OPTIONS=$JAVA_OPTIONS"
echo "JAVA VERSION:"
echo "$(java --version)"
# exec command is very important here
# otherwise graceful is not working since
# only the shell script receives the SIGTERM command
# but it doesn't propagate it to the java process.
# so eventually the java process gets killed, which is not graceful ;)
echo "Now, java process is executed..."
exec $JAVA_HOME/bin/java $JAVA_OPTIONS -jar /app/application.jar $@
