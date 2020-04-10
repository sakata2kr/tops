# Start with a base image containing Java runtime
FROM java:8

# Add Author info
LABEL maintainer="sakata2@gmail.com"

# Add a volume to /tmp
VOLUME /tmp

# Make port 8080 available to the world outside this container
EXPOSE 8080

# The application's jar file
ARG JAR_FILE=target/tops-0.0.2.jar

# Add the application's jar to the container
ADD ${JAR_FILE} tops.jar

# Run the jar file
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/tops.jar"]

java -Djava.security.edg=file:/dev/./urandom -jar target/tops-0.0.2.jar