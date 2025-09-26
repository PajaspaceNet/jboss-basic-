# JBoss / WildFly – Konfigurace

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



* **Deployments** → nasazené aplikace (WAR, EAR soubory)

---

## Správa a konfigurace

Na rozdíl od Apache (který má jeden soubor `httpd.conf`) je možné JBoss konfigurovat několika způsoby:

* **Přímo v XML** (`standalone.xml`)
* **Přes webovou Management konzoli** ([http://localhost:9990](http://localhost:9990))
* **Přes CLI** (`jboss-cli.sh`)

Ukázkový CLI příkaz:

```bash
/subsystem=logging/logger=org.jboss.as:add(level=DEBUG)
```
 


