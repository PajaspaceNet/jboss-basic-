#!/bin/bash
# Automatická instalace WildFly (Linux)
WILDFLY_VERSION=37.0.1.Final
cd /tmp
wget https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz
sudo tar -xvzf wildfly-$WILDFLY_VERSION.tar.gz -C /opt/
sudo mv /opt/wildfly-$WILDFLY_VERSION /opt/wildfly
echo "WildFly nainstalován do /opt/wildfly"
