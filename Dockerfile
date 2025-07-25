FROM ibmjava:jre
RUN mkldir /app
COPY /target/banking-app-0.0.1-SNAPSHOT.jar /app
CMD ["java", "-jar", "/app/banking-app-0.0.1-SNAPSHOT.jar"]
