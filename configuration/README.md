# Konfigurace uživatele a serveru

1. Přidání správce pro konzoli:

./add_wildfly_user.sh

2. Otevření portů ve firewallu (Linux):

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --add-port=9990/tcp --permanent
sudo firewall-cmd --reload

3. Start serveru:

/opt/wildfly/bin/standalone.sh -b=0.0.0.0 