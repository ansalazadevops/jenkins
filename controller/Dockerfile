# ---------------------------------------------------------------------------
# Jenkins controller
#
# Built on the official LTS image (jdk21 — Jenkins' current recommended JDK).
# We bake in the plugins we need and a Jenkins Configuration as Code (JCasC)
# file so the whole instance — admin user, credentials AND the SSH agent node
# — comes up fully configured with zero clicking.
# ---------------------------------------------------------------------------
FROM jenkins/jenkins:latest

# Skip the interactive setup wizard — JCasC owns the configuration.
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
# Tell JCasC where to find its config (kept OUTSIDE the jenkins_home volume).
ENV CASC_JENKINS_CONFIG=/var/jenkins_config/casc.yaml

# Install plugins listed in plugins.txt (dependencies resolved automatically).
COPY controller/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Ship the JCasC configuration.
COPY controller/casc.yaml /var/jenkins_config/casc.yaml
