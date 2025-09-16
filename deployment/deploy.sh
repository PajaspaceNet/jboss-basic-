#!/bin/bash
# Deploy demo-app.war přes JBoss/WildFly CLI
JBOSS_CLI=/opt/wildfly/bin/jboss-cli.sh
WAR_PATH="$(pwd)/demo-app/target/demo-app.war"

echo "Nasazuji demo-app.war..."
$JBOSS_CLI --connect "deploy $WAR_PATH --force"
echo "Hotovo! Stav nasazení:"
$JBOSS_CLI --connect ":deployment-info"
