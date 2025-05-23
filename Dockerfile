# Build stage
FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Runtime stage
FROM tomcat:9-jdk11
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/calculator.war

