# Stage 1: Build stage
FROM maven:3.8-openjdk-11 AS builder

# Set working directory
WORKDIR /app

# Copy the pom.xml to download dependencies
COPY pom.xml .

# Download dependencies to cache them in a separate layer
RUN mvn dependency:go-offline -B

# Copy source code 
COPY src ./src

# Skip tests for faster build (-DskipTests)
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]