FROM openjdk:17-jdk-slim
WORKDIR /app
ENV PORT 6655
COPY target/java-one.jar /app/java-one.jar
EXPOSE 6655
ENTRYPOINT ["java", "-jar", "/app/java-one.jar"]