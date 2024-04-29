# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

# Copy the pom.xml file and download the dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Build the application
RUN mvn package

# Stage 2: Create the runtime image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port on which the application will run
EXPOSE 9001

# Run the application
CMD ["java", "-jar", "app.jar"]