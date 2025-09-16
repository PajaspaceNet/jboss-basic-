# Instalace WildFly

1. Stáhnout WildFly z oficiálních stránek:

wget https://github.com/wildfly/wildfly/releases/download/37.0.1.Final/wildfly-37.0.1.Final.tar.gz

2. Rozbalit do `/opt/wildfly`:

sudo tar -xvzf wildfly-37.0.1.Final.tar.gz -C /opt/
sudo mv /opt/wildfly-37.0.1.Final /opt/wildfly

3. Nastavit vlastního uživatele pro správu:

./add-user.sh

4. Spustit server:

/opt/wildfly/bin/standalone.sh -b=0.0.0.0