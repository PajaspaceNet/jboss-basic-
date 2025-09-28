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



V adresáři JBossu (resp. WildFly) najdeš konfigurační soubory pro **standalone režim**:

```
$JBOSS_HOME/standalone/configuration/
```

Uvnitř jsou hlavně tyto soubory:

* **standalone.xml** – základní konfigurace serveru (datasources, JMS, subsystémy, logging, bezpečnost).
* **standalone-full.xml** – varianta s víc subsystémy (JMS, Clustering, atd.).
* **standalone-ha.xml** – konfigurace pro high availability (clustering).
* **standalone-full-ha.xml** – kombinace full + HA.
* **standalone-load-balancer.xml** – pokud je JBoss použit jako load balancer.

Typicky se používá **standalone.xml** (pokud nespouštíš server s jiným profilem).

Když spustíš JBoss příkazem:

```bash
$JBOSS_HOME/bin/standalone.sh
```

→ použije se výchozí `standalone.xml`.

Pokud chceš jiný soubor, dáš parametr `--server-config`, např.:

```bash
$JBOSS_HOME/bin/standalone.sh --server-config=standalone-full.xml
```
| Soubor / adresář                                                 | Popis                                                  | Kdy použít                                                      | Typické úpravy                                                                  |
| ---------------------------------------------------------------- | ------------------------------------------------------ | --------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| **standalone.xml**                                               | Základní konfigurace serveru.                          | Výchozí profil při spuštění `standalone.sh`.                    | Přidání datasource, definice JNDI, úprava subsystémů (např. logging, security). |
| **standalone-full.xml**                                          | Rozšířený profil s více subsystémy (JMS, batch, atd.). | Pokud aplikace používá messaging nebo další enterprise featury. | Konfigurace JMS front/topic, batch subsystému, rozšířených služeb.              |
| **standalone-ha.xml / standalone-full-ha.xml**                   | Varianta pro clustering a vysokou dostupnost.          | Při nasazení více instancí JBossu do clusteru.                  | Nastavení discovery group, infinispan cache, session clustering.                |
| **standalone-microprofile.xml / standalone-microprofile-ha.xml** | Profil s podporou MicroProfile API.                    | Pokud aplikace využívá MicroProfile (health, metrics, config).  | Konfigurace health check endpointů, metrics, config sources.                    |
| **standalone-load-balancer.xml**                                 | Server jako load balancer (mod_cluster).               | Pokud JBoss funguje jako fronta pro jiné servery.               | Úprava mod_cluster konfigurace, worker nodes.                                   |
| **standalone_xml_history/**                                      | Automatické zálohy konfiguračních XML.                 | Server si ukládá změny provedené přes CLI/kontrolní konzoli.    | Obnova starší konfigurace při chybě.                                            |
| **application-users.properties / application-roles.properties**  | Uživatelé a role pro aplikace (JAAS).                  | Pokud aplikace používá `Database`/`Properties` login modul.     | Přidání uživatelů a přiřazení rolí.                                             |
| **mgmt-users.properties / mgmt-groups.properties**               | Uživatelé a skupiny pro administraci.                  | Pro přístup do admin konzole (`http://localhost:9990`) a CLI.   | Přidání admin uživatele pomocí `add-user.sh`.                                   |
| **application.keystore**                                         | Certifikáty pro HTTPS/TLS.                             | Pokud chceš aplikaci nebo konzoli zpřístupnit přes HTTPS.       | Import/obnova certifikátů, změna hesla keystore.                                |
| **logging.properties**                                           | Konfigurace logování (úrovně, appendery).              | Pro nastavení formátu, úrovní a cílů logů.                      | Přidání vlastních loggerů, změna úrovně logování.                               |

---




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
## SHrnuti 

👉 Přehled obou nejčastějších možností – properties soubor pro správu a databázový realm pro aplikace.


* **Deployments** → nasazené aplikace (WAR, EAR soubory)

---


 **JBoss/WildFly** (novější název) se může lišit podle verze a způsobu nasazení (standalone vs. domain mode). Obecný postup je ale zhruba takto:

---

### 1. Struktura aplikace

* Aplikace se obvykle balí jako:

  * **WAR** (pro webové aplikace),
  * **EAR** (pokud má více modulů, např. EJB + WAR),
  * nebo **JAR** (pokud jde o čistě EJB modul).
* Konfigurace aplikace se dá částečně řídit pomocí souborů v `WEB-INF` (web.xml, jboss-web.xml) nebo `META-INF` (persistence.xml, jboss-deployment-descriptor.xml).

---

### 2. Nasazení aplikace

* V **standalone režimu** se aplikace jednoduše zkopíruje do adresáře:

  ```
  $JBOSS_HOME/standalone/deployments/
  ```

  (např. `standalone/deployments/mojeapp.war`)
* V **domain režimu** se nasazuje přes doménového kontrolera (CLI nebo konzole).

---

### 3. Konfigurace JBossu

Aplikace často potřebuje:

* **Datasource** (pro přístup k DB),
* **JMS Queue/Topic** (pokud používá messaging),
* **Bezpečnostní realms** (uživatelé, role, LDAP, apod.),
* **System properties**.

Tyto věci se nastavují v konfiguračních souborech JBossu:

* `standalone/configuration/standalone.xml`
* (nebo `domain/configuration/domain.xml` v domain mode).

# Basic Settings (JBoss/WildFly) zakladni veci u kazde aplikace

| Typ nastavení | Popis | Typické použití |
|---------------|-------|-----------------|
| **Datasource (JDBC)** | Připojení k databázi, definice driveru a connection URL. | Téměř každá aplikace používá DB → nastavuje se v `<datasources>` v `standalone.xml`. |
| **JMS (Messaging)** | Fronty a topics pro messaging. | Pokud aplikace potřebuje asynchronní komunikaci nebo messaging (ActiveMQ, Artemis). |
| **Security (uživatelé, role)** | Uživatelé a role pro aplikace (`application-users.properties`) nebo management (`mgmt-users.properties`). | Přidání loginů pro aplikace nebo admin konzoli, integrace s LDAP/Keycloak. |
| **Deployment (nasazení aplikace)** | Nasazení `.war`, `.ear`, `.jar` do `standalone/deployments/`. | Nejjednodušší způsob, jak spustit aplikaci na serveru. |
| **Logging** | Nastavení loggerů a úrovní logů (`INFO`, `DEBUG`, `ERROR`). | Řešení logování aplikací i serveru, úprava `<subsystem xmlns="...logging...">`. |
| **Networking (socket-binding, konektory)** | HTTP (8080), HTTPS (8443), další porty. | Změna portů, přidání SSL certifikátu, konfigurace HTTPS konektoru. |

---

## Specifická nastavení

| Typ nastavení | Popis | Typické použití |
|---------------|-------|-----------------|
| **Clustering / HA** | Nastavení pro běh více instancí serveru (Infinispan, session replication). | Produkční prostředí s vysokou dostupností. |
| **MicroProfile** | Health checks, metrics, config API. | Cloud-native aplikace a monitoring. |
| **Batch jobs** | Konfigurace batch subsystému. | Aplikace, které spouští dávkové úlohy. |
| **Load balancer (mod_cluster)** | Konfigurace serveru jako load balancer. | Pokud WildFly funguje jako fronta pro další nody. |
| **Externí služby** | Integrace s Active Directory, Keycloak, messaging brokers apod. | Enterprise integrace. |


---

### 4. Management konzole a CLI

JBoss má dvě hlavní cesty konfigurace:

* **Webová administrátorská konzole** (defaultně na `http://localhost:9990`).
* **CLI nástroj** (`$JBOSS_HOME/bin/jboss-cli.sh`), kterým lze:

  * přidat datasource,
  * nakonfigurovat JMS,
  * měnit system properties,
  * provádět deployment aplikací.

---

### 5. Konfigurace uvnitř aplikace

* Pokud potřebuješ aplikaci konfigurovat dynamicky (např. parametry DB, URL služeb), používá se často:

  * **JNDI bindingy**,
  * **Environment entries** (v `web.xml`),
  * **System properties** (čtené přes `System.getProperty`).

---



