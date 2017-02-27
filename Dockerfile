FROM openjdk

COPY target/simple-junit-1.0-SNAPSHOT.jar simple-junit.jar
ENTRYPOINT ["java","-jar","simple-junit.jar"]
