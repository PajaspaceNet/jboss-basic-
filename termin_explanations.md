# Termin Explanation

# Basic Explanations – JBoss / WildFly

Tento dokument shrnuje nejčastější základní pojmy, které se objevují při práci s JBoss / WildFly (EAP).  

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

