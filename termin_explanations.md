# Termin Explanation

### Basic Explanations – JBoss / WildFly

Shrnuti nejčastější základní pojmy, které se objevují při práci s JBoss / WildFly (EAP).  

---

| Pojem                  | Vysvětlení (stručně)                                             | Příklad použití |
|-------------------------|------------------------------------------------------------------|-----------------|
| **LDAP / Active Directory** | Adresářová služba, kde jsou uživatelé, skupiny, role. Přístup přes protokol LDAP. | Login do aplikace přes firemní AD. |
| **DN / CN / OU / DC**   | Struktura LDAP: DN = cesta k objektu, CN = jméno, OU = jednotka, DC = doména. | `CN=Jan Novak,OU=People,DC=firma,DC=cz` |
| **Connection Pool**     | Správa připojení k databázi, aby se neotvírala stále nová spojení. | Datasource v JBossu s max. 20 connections. |
| **DataSource (JNDI)**   | Definice zdroje dat (DB) v aplikačním serveru. | `java:/MyDS` odkazující na databázi. |
| **JNDI**                | Java Naming and Directory Interface – způsob, jak aplikace najde zdroje. | Lookup datasource nebo JMS fronty. |
| **JMS**                 | Java Messaging Service – zprávy ve frontách nebo topics. | Asynchronní zpracování objednávek. |
| **EJB**                 | Enterprise Java Beans – komponenty pro business logiku. | EJB session bean v aplikaci. |
| **WAR / EAR**           | Formáty balíčků pro nasazení aplikací. | `app.war` (web), `erp.ear` (enterprise). |
| **Deployment Descriptor** | XML konfigurace určující chování aplikace. | `web.xml`, `jboss-web.xml`. |
| **Cluster**             | Seskupení více JBoss instancí pro škálování a HA. | Dva servery sdílející session. |
| **Session Replication** | Replikace uživatelských session v clusteru. | Uživatel zůstane přihlášen i při výpadku 1 uzlu. |
| **Thread Pool**         | Správa vláken pro obsluhu požadavků. | Webová aplikace zpracuje více requestů najednou. |
| **Garbage Collection**  | Mechanismus JVM pro uvolňování paměti. | Ladění GC logů při OutOfMemoryError. |
| **Classloading**        | Způsob, jak JVM/JBoss načítají třídy a knihovny. | Konflikt knihoven → `ClassNotFoundException`. |
| **Security Domain / Elytron** | Konfigurace autentizace a autorizace v JBossu. | Přihlášení uživatele přes LDAP. |
| **Logging Subsystem**   | Správa logování v JBossu. | Nastavení logů v `standalone.xml`. |
| **JTA (Java Transaction API)** | Správa transakcí napříč DB a komponentami. | Commit/rollback více databází současně. |

---




## LDAP

👉 LDAP = Lightweight Directory Access Protocol<br>
(v překladu: lehký protokol pro přístup k adresářovým službám).<br>

📌 Jednoduše řečeno:<br>
**LDAP** je protokol, kterým se přistupuje k tzv. adresářové službě – databázi, <br>
kde jsou uložení uživatelé, skupiny, hesla, přístupová práva, počítače apod.<br>

<pre>
+-----------+       login (jméno+heslo)       +-------------+       ověření/role       +--------------------+
| Uživatel  | -----------------------------> |   JBoss      | ---------------------> |   LDAP / AD        |
|           |                                |   Server     | <--------------------- |  adresářová služba |
+-----------+       přístup k aplikaci       +-------------+     potvrzení/přístup   +--------------------+
</pre>



Příklad z praxe:

Firma má stovky zaměstnanců.<br>

Každý má uživatelské jméno, heslo, oddělení, roli.<br>

Tyto údaje se ukládají do centrální adresářové služby (typicky Microsoft Active Directory).<br>

Aplikace nebo servery (třeba i JBoss) pak přes LDAP ověřují, jestli je uživatel oprávněný se přihlásit, a jaké má role.<br>



| Zkratka | Název (EN)          | Význam / k čemu slouží                    | Příklad hodnoty                         |
| ------- | ------------------- | ----------------------------------------- | --------------------------------------- |
| **DC**  | Domain Component    | Doménová komponenta (část názvu domény)   | `DC=firma`, `DC=cz`                     |
| **OU**  | Organizational Unit | Organizační jednotka (jako složka)        | `OU=People`, `OU=Groups`                |
| **CN**  | Common Name         | Obecné jméno objektu (uživatel, skupina…) | `CN=Jan Novak`                          |
| **DN**  | Distinguished Name  | Celá unikátní cesta k objektu             | `CN=Jan Novak,OU=People,DC=firma,DC=cz` |


## Základní pojmy

**DC (Domain Component)** → doména, např. DC=firma,DC=cz<br>
**OU (Organizational Unit)** → organizační jednotka, např. OU=People<br>
**CN (Common Name)** → běžné jméno, např. CN=Jan Novak<br>


<pre>
dn: CN=Jan Novak,OU=People,DC=firma,DC=cz
objectClass: person
cn: Jan Novak
sn: Novak
uid: jnovak
mail: jan.novak@firma.cz
memberOf: CN=Admins,OU=Groups,DC=firma,DC=cz
</pre>

**DN** = celá cesta k objektu<br>
**CN** = konkrétní jméno záznamu<br>
**OU** = složka / organizační jednotka<br>
**DC** = doména<br>


Jak to funguje:

Active Directory / LDAP je vlastně speciální databáze.<br>
Data (uživatelská jména, hesla – uložená jako hashe, role, skupiny…) jsou uložená na disku serveru, který běží jako adresářová služba.<br>
Když aplikace (např. JBoss) ověřuje uživatele, pošle dotaz na LDAP server → ten sáhne do databáze a vrátí odpověď.<br>

Aby to bylo rychlé, server si některé věci může cacheovat v paměti (RAM), ale primárně je to uložené na disku.<br>

Údaje nejsou jen v paměti – jsou perzistentně uložené na serveru v adresářové databázi.<br> 
Paměť se používá jen pro zrychlení přístupu.<br>



## Proč je to důležité:

Aplikace nebo servery (třeba i JBoss) pak přes LDAP ověřují, <br>
jestli je uživatel oprávněný se přihlásit, a jaké má role.<br>
Centralizace: správa uživatelů je na jednom místě, ne v každé aplikaci zvlášť.<br>

Bezpečnost: jednotné heslo, role, rychlé zablokování účtu.<br>

Integrace: spousta systémů (mail, databáze, intranet, JBoss) se umí napojit na LDAP.<br>

💡 V kontextu JBossu:<br>
Když nasadíš aplikaci a chceš, aby se uživatelé přihlašovali<br> 
firemním jménem a heslem, nastavíš v JBossu security domain nebo<br>
Elytron, který se napojí na LDAP/Active Directory<br>

---

## Conection pool 

<pre>
[ Aplikace / request ]
          |
          v
   [ Connection Pool ] --(není volno)--> čekání podle acquire-timeout
          |
          v
    [ DB spojení ] <-> [ Databáze ]
          |
          v
   vrácení do poolu  (nezapomeň close() / u managed DS řeší kontejner)


</pre>



| Pojem / parametr                           | Co znamená                             | Proč je důležité                                  | Poznámka / příklad                                       |
| ------------------------------------------ | -------------------------------------- | ------------------------------------------------- | -------------------------------------------------------- |
| **Pool**                                   | Sdílená sada otevřených DB spojení     | Šetří čas (neotvírá se spojení při každém dotazu) | V JBossu konfiguruješ v datasource                       |
| **min-pool-size**                          | Minimální počet otevřených spojení     | Zahřejí pool, rychlé první requesty               | Např. 5                                                  |
| **max-pool-size**                          | Maximální počet spojení v poolu        | Limituje paralelismus a zátěž DB                  | Např. 20–50 dle DB a zátěže                              |
| **acquire-timeout / blocking-timeout**     | Jak dlouho čekat na volné spojení      | Zabraňuje nekonečnému čekání                      | Např. 30 s                                               |
| **idle-timeout**                           | Jak dlouho může být spojení nečinné    | Čistí neaktivní spojení                           | Např. 5–15 min                                           |
| **validation**                             | Ověření, že spojení je živé            | Zabraňuje předávání mrtvých spojení aplikaci      | `check-valid-connection-sql` nebo validátor driveru      |
| **test-on-borrow / background-validation** | Kdy se validuje spojení                | Na půjčení vs. periodicky na pozadí               | Background méně zatěžuje request                         |
| **validation-query**                       | SQL pro ověření spojení                | Musí být levné a vždy platné                      | Oracle: `SELECT 1 FROM DUAL`, Postgres/MySQL: `SELECT 1` |
| **leak-detection**                         | Detekce úniků (neuzavřených) spojení   | Pomáhá najít místa bez `close()`                  | Loguje stacktrace držitele spojení                       |
| **prepared-statement-cache**               | Cache prepared statements na připojení | Zrychluje opakované dotazy                        | Nastavit velikost dle aplikace                           |
| **transaction-isolation**                  | Izolační úroveň transakcí              | Ovlivňuje zámky/konflikty/konzistenci             | Default DB (často READ COMMITTED)                        |
| **auto-commit**                            | Automatický commit po každém dotazu    | Většinou vypnuto v řízených transakcích (JTA)     | Spravuje kontejner                                       |
| **pool-strategy**                          | Jak se vytváří/ničí spojení            | Může být „prefill“, „on-demand“                   | Prefill = rychlý start, vyšší nároky                     |

 ## Common Problemms

| Problém / symptom                                 | Pravděpodobná příčina                                                              | Rychlé řešení                                                                                      |
| ------------------------------------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **„Pool vyčerpán“ / time-out na získání spojení** | Příliš nízký `max-pool-size`, únik spojení (nevolá se `close()`), dlouhé DB dotazy | Zvedni `max-pool-size` (rozumně), zapni **leak detection**, zkrať pomalé dotazy, přidej indexy     |
| **Náhodné DB chyby po nečinnosti**                | DB zavírá idle spojení, chybí validace                                             | Nastav `background-validation` a `validation-query`, případně `idle-timeout`                       |
| **„Stale/closed connection“**                     | Spojení umřelo mezi půjčením a použitím                                            | Zapni `test-on-borrow` nebo krátký `background-validation` interval                                |
| **Pomalé requesty při špičce**                    | Malý pool, velké „spiky“, dlouhé transakce                                         | Optimalizuj dotazy, zkrať transakce, zvaž vyšší `max-pool-size` a větší `prepared-statement-cache` |
| **Zámky / deadlocky**                             | Dlouhé transakce, nevhodná izolační úroveň                                         | Zkrať transakce, přepni izolaci (např. na READ COMMITTED), reviduj pořadí update tabulek           |
| **Časté reconnecty**                              | Krátký `idle-timeout`, agresivní firewall/DB timeout                               | Slaď `idle-timeout` s DB, zapni background validation                                              |
| **Vysoká zátěž DB**                               | Příliš velký pool nebo chybějící limity na dotazy                                  | Sniž `max-pool-size`, optimalizuj SQL, rate-limit batch úlohy                                      |
| **„Too many open cursors“ (Oracle)**              | Malý limit kurzorů nebo bezhlavé statementy bez close                              | Zvyšit DB limit, používat prepared statements a správně zavírat                                    |
| **„Connection leak suspected“ v logu**            | Aplikace neuzavírá spojení ve všech cestách                                        | Všude `try/finally` (`try-with-resources`), log z leak-detektoru použij na fix                     |
| **Flapping validace (falešné chyby)**             | Těžká `validation-query` / nestabilní síť                                          | Použij nejlevnější validaci, stabilizuj síťové parametry/timeouty                                  |




 **datasource snippet s vysvětlivkami**
 👉Basic  příklad – 

# Datasource – ukázková konfigurace (standalone.xml)

```xml
<subsystem xmlns="urn:jboss:domain:datasources:5.0">
    <datasources>
        <!-- Definice datasource -->
        <datasource jndi-name="java:/MyDS" pool-name="MyDS_Pool" enabled="true" use-java-context="true">
            
            <!-- URL připojení k databázi -->
            <connection-url>jdbc:postgresql://dbhost:5432/mydb</connection-url>
            <driver>postgresql</driver>

            <!-- Uživatelské jméno a heslo -->
            <security>
                <user-name>myuser</user-name>
                <password>mypassword</password>
            </security>

            <!-- ⚙️ Pool settings: nastavení počtu spojení -->
            <pool>
                <min-pool-size>5</min-pool-size>           <!-- minimální počet spojení -->
                <max-pool-size>20</max-pool-size>          <!-- maximální počet spojení -->
                <prefill>true</prefill>                    <!-- zda se spojení vytvoří hned při startu -->
            </pool>

            <!-- ⏱️ Timeout settings: čekání a čištění -->
            <timeout>
                <blocking-timeout-millis>30000</blocking-timeout-millis> <!-- max. čekání na spojení (30 s) -->
                <idle-timeout-minutes>5</idle-timeout-minutes>           <!-- jak dlouho může být spojení nečinné -->
            </timeout>

            <!-- ✅ Validation settings: kontrola, že spojení je živé -->
            <validation>
                <check-valid-connection-sql>SELECT 1</check-valid-connection-sql> <!-- jednoduchý testovací SQL dotaz -->
                <background-validation>true</background-validation>               <!-- zapnout kontrolu na pozadí -->
                <background-validation-millis>30000</background-validation-millis> <!-- interval validace (30 s) -->
            </validation>
        </datasource>

        <!-- 🔌 Driver definition: definice JDBC driveru -->
        <drivers>
            <driver name="postgresql" module="org.postgresql">
                <driver-class>org.postgresql.Driver</driver-class>
            </driver>
        </drivers>
    </datasources>
</subsystem>
```

---

### 📖 Vysvětlivky bloků

* **`connection-url`** – JDBC URL k databázi (host, port, název DB).
* **`security`** – přihlašovací údaje (pozor: v produkci často řešeno jinak – vault, credential store).
* **`pool`** – kolik spojení se udržuje minimálně, kolik maximálně, jestli se vytvoří hned.
* **`timeout`** – jak dlouho čeká aplikace na volné spojení, kdy se vyhazují idle spojení.
* **`validation`** – jak se kontroluje, že spojení funguje (query `SELECT 1`), zda se dělá test při každém půjčení nebo na pozadí.
* **`drivers`** – definice JDBC driveru, který musí být nainstalovaný jako modul v JBoss/WildFly.

---




