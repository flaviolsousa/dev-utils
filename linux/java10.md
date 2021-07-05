# Install Oracle Java 10 (JDK 10) on Mint

### Install

```sh
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt install oracle-java12-installer
```

### Set to default (PATH and JAVA_HOME)

```sh
sudo apt install oracle-java12-set-default
```

### Unset default

```sh
sudo apt remove oracle-java12-set-default
```
