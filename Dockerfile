#FROM maven:3.8.7 AS build
#WORKDIR /app
#COPY . .
#RUN mvn clean package -DskipTests
#
#FROM openjdk:17
#WORKDIR /app
#COPY --from=build /app/target/*.jar crudApp-0.0.1-SNAPSHOT.jar
#ENTRYPOINT ["java", "-jar", "crudApp-0.0.1-SNAPSHOT.jar"]


# Use an official base image
FROM ubuntu:24.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    openjdk-17 \
    docker.io \
    git \
    unzip

# Install Elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-amd64.deb \
    && dpkg -i elasticsearch-7.10.1-amd64.deb

# Install SonarQube
RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.7.0.41497.zip \
    && unzip sonarqube-8.7.0.41497.zip -d /opt

# Install Grafana
RUN wget https://dl.grafana.com/oss/release/grafana_7.3.6_amd64.deb \
    && dpkg -i grafana_7.3.6_amd64.deb

# Install Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz \
    && tar xvfz prometheus-2.24.1.linux-amd64.tar.gz -C /opt

# Install Trivy
RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.16.0/trivy_0.16.0_Linux-64bit.deb \
    && dpkg -i trivy_0.16.0_Linux-64bit.deb

# Expose necessary ports
EXPOSE 9200 9000 3000 9090 5044

# Start all services (for demonstration purposes; in a real scenario, use a proper init system)
CMD service elasticsearch start && \
    /opt/sonarqube-8.7.0.41497/bin/linux-x86-64/sonar.sh start && \
    service grafana-server start && \
    /opt/prometheus-2.24.1.linux-amd64/prometheus
