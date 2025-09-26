# Konfigurace uživatele a serveru

1. Přidání správce pro konzoli:

./add_wildfly_user.sh

2. Otevření portů ve firewallu (Linux):

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --add-port=9990/tcp --permanent
sudo firewall-cmd --reload

3. Start serveru:


/opt/wildfly/bin/standalone.sh -b=0.0.0.0 


# JBoss / WildFly – Konfigurace

## Správa a konfigurace

Na rozdíl od Apache (který má jeden soubor `httpd.conf`) je možné JBoss konfigurovat několika způsoby:

* **Přímo v XML** (`standalone.xml`)
* **Přes webovou Management konzoli** ([http://localhost:9990](http://localhost:9990))
* **Přes CLI** (`jboss-cli.sh`)

Ukázkový CLI příkaz:

```bash
/subsystem=logging/logger=org.jboss.as:add(level=DEBUG)
```
 

JBoss (WildFly) ukládá své konfigurační soubory do:

- `standalone/configuration/` – pro samostatný (standalone) server  
- `domain/configuration/` – pro doménový režim (více serverů spravovaných společně)  

Nejpoužívanější soubor je **`standalone.xml`** (nebo `domain.xml`).

---

## Co se nastavuje v `standalone.xml`

**Interfaces** → na jakých IP adresách a portech server poslouchá
   
 ```
  <interfaces>
      <interface name="public">
          <inet-address value="${jboss.bind.address:0.0.0.0}"/>
      </interface>
  </interfaces>
 ```

 **Subsystems** → moduly jako datasources, logging, security, deployment scanner

* **Datasources** → připojení k databázím (JDBC URL, uživatel, heslo)

  ```xml
  <datasource jndi-name="java:/MyDS" pool-name="MyDS">
      <connection-url>jdbc:postgresql://localhost:5432/mydb</connection-url>
      <driver>postgresql</driver>
      <security>
          <user-name>dbuser</user-name>
          <password>secret</password>
      </security>
  </datasource>
  ```

* **Security realms** → autentizace uživatelů, účty pro správu

 malý a jednoduchý příklad, jak se v **`standalone.xml`** definuje **security realm** pro správu uživatelů:

```xml
<management>
    <security-realms>
        <security-realm name="ManagementRealm">
            <authentication>
                <local default-user="$local" allowed-users="*" skip-group-loading="true"/>
                <properties path="mgmt-users.properties" relative-to="jboss.server.config.dir"/>
            </authentication>
        </security-realm>
    </security-realms>
</management>
```

---

### 🔎 Co to znamená:

* `ManagementRealm` → název realm-u (používá se pro přihlášení do konzole na portu 9990).
* `<authentication>` → definuje způsob přihlášení.
* `mgmt-users.properties` → soubor, kde jsou uložení uživatelé a hesla. Najdeš ho ve složce `standalone/configuration/`.

Ukázka obsahu `mgmt-users.properties`:

```
admin=4e5b6c7d8f9a1234567890abcdef
```

(tady je heslo uložené v hashované podobě)

---

👉 V praxi:

* Když přidáš uživatele pomocí skriptu `add-user.sh` (v Linuxu) nebo `add-user.bat` (ve Windows), JBoss ti do toho `mgmt-users.properties` automaticky zapíše nového uživatele.
* Potom se s tímto uživatelem přihlásíš do Management konzole (`http://localhost:9990`).

---


## Security Realms

Security realms slouží pro správu autentizace uživatelů – buď pro **management konzoli**, nebo pro samotné **aplikace**.

### 🔹 1. Management Realm (mgmt-users.properties)

Výchozí nastavení pro přístup do management konzole (http://localhost:9990).  
Uživatelé se ukládají do souboru `mgmt-users.properties`.

Ukázka v `standalone.xml`:
```xml
<management>
    <security-realms>
        <security-realm name="ManagementRealm">
            <authentication>
                <local default-user="$local" allowed-users="*" skip-group-loading="true"/>
                <properties path="mgmt-users.properties" relative-to="jboss.server.config.dir"/>
            </authentication>
        </security-realm>
    </security-realms>
</management>
````

---

### 🔹 2. Database Realm (aplikace)

Uživatelé a role se ukládají do databáze, připojené přes datasource (`java:/MyDS`).

Ukázka nastavení:

```xml
<management>
    <security-realms>
        <security-realm name="AppRealm">
            <authentication>
                <jaas name="DatabaseRealm"/>
            </authentication>
        </security-realm>
    </security-realms>
</management>
```

Konfigurace JAAS modulu:

```xml
<subsystem xmlns="urn:jboss:domain:security:2.0">
    <security-domains>
        <security-domain name="DatabaseRealm" cache-type="default">
            <authentication>
                <login-module code="Database" flag="required">
                    <module-option name="dsJndiName" value="java:/MyDS"/>
                    <module-option name="principalsQuery"
                      value="SELECT password FROM users WHERE username=?"/>
                    <module-option name="rolesQuery"
                      value="SELECT role, 'Roles' FROM user_roles WHERE username=?"/>
                    <module-option name="hashAlgorithm" value="SHA-256"/>
                </login-module>
            </authentication>
        </security-domain>
    </security-domains>
</subsystem>
```

Typické tabulky:

* **users**: `username`, `password (hash)`
* **user_roles**: `username`, `role`

---

👉 Přehled obou nejčastějších možností – properties soubor pro správu a databázový realm pro aplikace.




* **Deployments** → nasazené aplikace (WAR, EAR soubory)

---




