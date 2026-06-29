# Testing the Jenkins Node Agents

To execute the agent test on the Jenkins Console, follow the steps below:

1. Login to the **Jenkins Console**.

2. Go to **Manage Jenkins -> Nodes**

3. Pickup the **Node** of your preference.

4. Then open the **Script Console** and run the `agent_console_test.groovy` script below:

> `agent_console_test.groovy`

```groovy
println "git --version".execute().text
println "java --version".execute().text
println "python3 --version".execute().text
println "pip3 --version".execute().text
println "terraform --version".execute().text
```

## To test the `agent_console_test_groovy` script locally, follow the steps below:

### Install the `JBang` using the official installer script

This method downloads the binary, configures your local profile, and automatically adds `JBang` to your system path

1. Open your terminal.

2. Run the installer script command:

```bash
curl -Ls https://sh.jbang.dev | bash -s - app setup
```

3. Reload your terminal profile to apply changes immediately:

```bash
source ~/.bashrc
```

## Execute the `agent_console_test.groovy` script in your local terminal

```bash
jbang agent_console_test.groovy 
```

> Notice that the first time, it takes some time to download **Groovy** if it is not installed.

i.e.

```log
[jbang] Downloading Groovy 4.0.30. Be patient, this can take several minutes...
[jbang] Installing Groovy 4.0.30...
[jbang] Resolving dependencies...
[jbang]    org.apache.groovy:groovy:4.0.30
[jbang] Dependencies resolved
[jbang] Building jar for agent_console_test.groovy...
```

Alternatively, you can run the same script with the Native Groovy command:

```bash
groovy agent_console_test.groovy
```
