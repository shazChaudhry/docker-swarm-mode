FROM openjdk

COPY **/target/simple-junit-1.0-SNAPSHOT.jar simple-junit.jar
ENTRYPOINT ["java","-cp","simple-junit.jar","com.hmkcode.junit.Math"]
