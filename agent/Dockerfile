FROM debian:13-slim

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install OpenJDK 21
RUN apt-get update && apt-get install -y --no-install-recommends && \
    # Fix for slim image bug where man page paths missing
    mkdir -p /usr/share/man/man1 /usr/share/man/man2 && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless && \
    # Clean up apt caches to minimize image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify the installation
RUN java -version

# Install Git
RUN apt update && \
    apt install -y --no-install-recommends git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*    

# Install Python and pip
RUN apt update && \
    apt install -y --no-install-recommends python3 python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    python3 --version && \
    pip3 --version

# Install Terraform
# Install minimal prerequisites required for adding the third-party repo
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg && \
    rm -rf /var/lib/apt/lists/*

# Download HashiCorp's official GPG key and register their repository
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com trixie main" > /etc/apt/sources.list.d/hashicorp.list

# Update package lists and install Terraform
RUN apt-get update && apt-get install -y --no-install-recommends \
    terraform && \
    rm -rf /var/lib/apt/lists/*

RUN terraform --version

# Install OpenSSH server
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create the jenkins user + the directories the agent needs.
#   /home/jenkins/agent  -> the agent "remote root" (remoteFS)
#   /run/sshd            -> required for sshd privilege separation
RUN useradd --create-home --home-dir /home/jenkins --shell /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh /home/jenkins/agent /run/sshd && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh

# Install the controller's PUBLIC key as an authorized key.
# (The matching private key is given to the controller as a Docker secret.)
COPY --chown=jenkins:jenkins ssh-keys/jenkins_agent_key.pub /home/jenkins/.ssh/authorized_keys
RUN chmod 600 /home/jenkins/.ssh/authorized_keys

# Lock the SSH daemon down: key-only auth, no root login, only the jenkins
# user may log in. Using a drop-in keeps us independent of distro defaults.
RUN printf '%s\n' \
        'PermitRootLogin no' \
        'PasswordAuthentication no' \
        'PubkeyAuthentication yes' \
        'AllowUsers jenkins' \
        > /etc/ssh/sshd_config.d/10-jenkins-agent.conf && \
    ssh-keygen -A

# Install prerequisites, AWS CLI v2, and clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf awscliv2.zip aws /var/lib/apt/lists/*

# Expose the SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
