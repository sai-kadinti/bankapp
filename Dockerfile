FROM ubuntu
RUN apt update && apt install openjdk-17-jdk
RUN mkdir /app
COPY /target/banking-app-0.0.1-SNAPSHOT.jar /app
CMD ["java", "-jar", "/app/banking-app-0.0.1-SNAPSHOT.jar"]
EXPOSE 8085
