# --- Stage 1: Build the application ---
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Compile and package the application into a JAR file
RUN mvn clean package -DskipTests

# --- Stage 2: Run the application ---
#FROM cgr.dev/chainguard/jre:latest
FROM registry.access.redhat.com/ubi8/openjdk-17
WORKDIR /app

# Copy only the built JAR file from the first stage
COPY --from=build /app/target/*.jar app.jar

USER 1001 

# Expose the application port (e.g., 8080)
EXPOSE 8080

# Execute the application
ENTRYPOINT ["java", "-jar", "app.jar"]
