#!/bin/sh

echo "Run scripts before starting your java app... (e.g. import SSL certificates)"
echo "JAVA_HOME=$JAVA_HOME"
echo "JAVA_OPTIONS=$JAVA_OPTIONS"
# exec command is very important here
# otherwise graceful is not working since
# only the shell script recieves the SIGERM command
# but it doesn't propagates it to the java process
exec /usr/bin/java $JAVA_OPTIONS -jar /app/application.jar $@