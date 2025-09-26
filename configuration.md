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
 


