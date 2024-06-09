FROM maven:3.8.7 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17
WORKDIR /app
COPY --from=build /app/target/*.jar crudApp-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "crudApp-0.0.1-SNAPSHOT.jar"]
