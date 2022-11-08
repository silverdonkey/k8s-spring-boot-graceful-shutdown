#!/bin/bash

echo "Running as User: $(whoami)"
echo "Using a shell as a pre-start hook."
echo "You can run scripts before starting your java app (e.g. import SSL certificates)"
echo "JAVA_HOME=$JAVA_HOME"
echo "JAVA_OPTIONS=$JAVA_OPTIONS"
# NO exec command here !!
# graceful shutdown is not working since
# only the shell script receives the SIGERM command
# but it doesn't propagates it to the java process
echo "Now, the java process is starting without exec..."
$JAVA_HOME/bin/java $JAVA_OPTIONS -jar /app/application.jar $@
