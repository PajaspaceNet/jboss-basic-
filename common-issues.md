# JBoss / WildFly – Common Issues & Basic Solutions

Seznam nejčastějších chyb, se kterými se lze setkat při práci s JBoss / WildFly (včetně EAP), a jejich základní řešení.  
Slouží jako rychlý **knowledge base** pro administrátory a vývojáře.

---

## Common Issues

| #  | Problém / Chybová hláška                           | Typická příčina                                                     | Základní řešení |
|----|-----------------------------------------------------|----------------------------------------------------------------------|-----------------|
| 1  | Server nelze nastartovat / nelze bindovat IP       | Chybí `-b` parametr nebo špatně nastavený hostname/IP                | Spustit s `-b 0.0.0.0` nebo opravit hosts/DNS |
| 2  | DeploymentException při nasazení                   | Chyby v XML (`web.xml`, `jboss-web.xml`, `standalone.xml`)           | Validovat XML, opravit namespace/tagy |
| 3  | ClassNotFoundException / NoClassDefFoundError      | Konflikt knihoven, chybějící modul, špatný classloading              | Upravit `jboss-deployment-structure.xml`, doplnit dependencies |
| 4  | OutOfMemoryError (Java heap space)                 | Málo paměti, paměťové úniky                                          | Zvýšit `-Xmx`, analyzovat heap pomocí VisualVM |
| 5  | PermGen / Metaspace Error                          | Starší JVM, mnoho tříd v classpath                                   | Zvýšit `-XX:MaxMetaspaceSize`, čistit nepotřebné knihovny |
| 6  | Pomalý start aplikace                              | Velké archivy, neoptimalizované deploymenty                          | Rozdělit WAR/EAR, odstranit nepotřebné knihovny |
| 7  | Full GC / vysoká zátěž JVM                         | Nevhodné GC nastavení, hodně objektů                                 | Ladit GC, logovat `-Xlog:gc*`, profilovat aplikaci |
| 8  | Connection pool vyčerpán                           | Neuzavřená spojení v kódu                                            | Vždy volat `close()` v `finally`, nastavit `check-valid-connection-sql` |
| 9  | Časté DB timeouty                                  | Malý pool, špatné nastavení timeoutu                                 | Zvýšit velikost poolu, nastavit timeouty, monitorovat DB |
| 10 | Session se nezachovává v clusteru                  | Chybí `distributable`, špatná cluster config                         | Přidat `distributable`, ověřit session-replication |
| 11 | Chyby JMS (messaging)                              | Chybí `libaio`, špatný journal, NFS disk                             | Instalovat `libaio`, použít NIO, lokální disk |
| 12 | „Address already in use“                           | Port koliduje s jiným procesem                                       | Změnit port v `standalone.xml`, ukončit kolidující proces |
| 13 | Security login chyby (LDAP, JAAS)                  | Špatná konfigurace security domain                                   | Ověřit bind DN, role, opravit konfiguraci login-modulů |
| 14 | Forbidden / 403 při přístupu k aplikaci            | Role/permissions chybně nastavené                                    | Zkontrolovat `web.xml`, `jboss-web.xml`, security domain |
| 15 | Slow deployment                                    | Scanují se velké složky, spousta tříd                                | Omezit scan, vyčistit deployment archivy |
| 16 | Logging nefunguje / nepíše do souboru              | Špatně nastavený `logging.properties` nebo subsystém                 | Upravit logging config ve `standalone.xml` |
| 17 | „Module not found“                                 | Chybí modul nebo špatná cesta                                        | Přidat modul do `$JBOSS_HOME/modules`, ověřit config |
| 18 | SSL / HTTPS chyby                                  | Chybí certifikát, špatná konfigurace `elytron` / `security-realm`    | Importovat certifikát, upravit `standalone.xml` |
| 19 | Upgrade → aplikace nefunguje                       | Změny v subsystémech mezi verzemi                                    | Číst release notes, provést migraci configu, testovat předem |
| 20 | Server spadne bez logu                             | Native knihovna chyba, segfault                                      | Ověřit JDK verzi, logovat s `-Xdiag`, nainstalovat potřebné knihovny |

---

## Poznámky
- Tento seznam je **obecný** – konkrétní prostředí může mít jiné příčiny.  
- Doporučeno vždy konzultovat oficiální dokumentaci [Red Hat JBoss EAP](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/) nebo [WildFly](https://docs.wildfly.org/).  
