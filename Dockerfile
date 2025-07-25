FROM ibmjava:jre
WORKDIR /opt/app
EXPOSE 9998
COPY /target/banking-app-0.0.1-SNAPSHOT.jar /opt/app
CMD ["java", "-jar", "/opt/app/banking-app-0.0.1-SNAPSHOT.jar"]
