# Use an official Ubuntu as a base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    software-properties-common \
    sudo \
    python3 \
    python3-pip \
    openjdk-11-jre-headless

# Install Docker inside the container
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Create a non-root user
RUN useradd -ms /bin/bash tpotuser && echo "tpotuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER tpotuser
WORKDIR /home/tpotuser

# Copy the pre-installed T-Pot directory
COPY --chown=tpotuser:tpotuser tpotce.tar.gz /home/tpotuser/
WORKDIR /home/tpotuser
RUN tar -xzvf tpotce.tar.gz

# Expose necessary ports
EXPOSE 64297 22 80 443 2222 3389 5900 8080 8888 9200 5000 3306 6379 7000

# Start the T-Pot service
CMD ["/home/tpotuser/tpotce/start.sh"]

