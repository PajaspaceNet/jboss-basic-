# JBoss/WildFly Basics

Tento repozitář slouží k nácviku a demonstraci základních operací s WildFly/JBoss:

- Instalace serveru
- Konfigurace uživatele a portů
- Deploy testovací Java aplikace (`demo-app.war`)
- Správa aplikací přes CLI a konzoli

## Struktura

- `installation/` – skripty a návody pro instalaci
- `deployment/` – testovací aplikace a deploy skripty
- `configuration/` – konfigurace uživatelů a serveru
- `services.md`  #  synchroni a asynchroni sluzby , vysvetleni
- `key_princips_a_osetrovani microservisu.md`  klicove principy a sprava microservicu

<pre>
  jboss-basics/
├── installation/
│   ├── README.md
│   └── install_wildfly.sh
├── deployment/
│   ├── demo-app/
│   │   ├── src/main/webapp/index.jsp
│   │   └── pom.xml
│   └── deploy_demo.sh
├── configuration/
│   ├── README.md
│   └── add_wildfly_user.sh
└── README.md
└── services.md  #  synchroni a asynchroni sluzby
└── key_princips_a_osetrovani microservisu.md # klicove principy a osetrovani microservicu
</pre>

## JAK SE NASAZUJE a ODSTRANUJE V JBOSSU

•	V WildFly / JBoss můžeš aplikaci nasadit několika způsoby:
1.	**`Kopírováním`**.war/.ear do složky deployments/ – WildFly ji automaticky nasadí.
   <pre>
   - sudo cp target/helloworld.war /opt/wildfly-XX/standalone/deployments/
   </pre>
    WildFly automaticky rozpozná WAR a spustí aplikaci.
2.	**`Přes management`** konzoli – nahrát .war a kliknout Enable.
3.	**`Přes CLI (jboss-cli.sh deploy)`** – příkazový  a ideální pro skripty nebo CI/CD.
    <pre>
  	/opt/wildfly-XX/bin/jboss-cli.sh --connect --command="deploy /cesta/k/helloworld.war"
    </pre>
    **Odstraneni prez CLI**
    <pre>  
  	/opt/wildfly-XX/bin/jboss-cli.sh --connect --command="undeploy helloworld.war"
    </pre>

   PREHLEDNE V TABULCE <br>

| Krok                         | Co se děje                                                | Kde/Co vzniká                                                                    | Jak se aplikuje/odstraňuje                                                                                                                                                                                            |
| ---------------------------- | --------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Zdrojové soubory**      | Píšeš Java třídy, JSP, HTML, CSS, konfigurace (`web.xml`) | `src/main/java/`, `src/main/webapp/`, `WEB-INF/`                                 | Je to výchozí obsah projektu, zatím není spustitelné                                                                                                                                                                  |
| **2. Maven build**           | Spuštění `mvn clean package`                              | Maven zkompiluje třídy, zabalí soubory do WAR a uloží do `target/`               | `target/helloworld.war` – hotová aplikace připravená k nasazení                                                                                                                                                       |
| **3. Deploy (nasazení)**     | Aplikace je nasazena na WildFly                           | WAR soubor je rozbalen WildFly v runtime (paměť + `standalone/deployments/`)     | a) Ručně: `cp target/helloworld.war /opt/wildfly-XX/standalone/deployments/` <br> b) Maven: `mvn wildfly:deploy` <br> c) CLI: `/opt/wildfly-XX/bin/jboss-cli.sh --connect --command="deploy /cesta/k/helloworld.war"` |
| **4. Běh aplikace**          | WildFly spouští aplikaci, dostupná přes prohlížeč         | běží v serveru, nezávisle na `target/`                                           | Otevřeš např.: `http://localhost:8080/helloworld`                                                                                                                                                                     |
| **5. Odstranění (undeploy)** | Aplikace je odstraněna ze serveru                         | WAR může zůstat v `target/` (není problém), ale server ji odstraní z deployments | a) Ručně: `rm /opt/wildfly-XX/standalone/deployments/helloworld.war` <br> b) Maven: `mvn wildfly:undeploy` <br> c) CLI: `/opt/wildfly-XX/bin/jboss-cli.sh --connect --command="undeploy helloworld.war"`              |


**Poznámky**

`target/` vzniká při Maven buildu (package) – před tím složka není.<br>

`WAR` v target/ je kopie připravená k deployi, server si ji buď rozbalí, nebo nasadí přímo.<br>

`undeploy` neodstraní soubor v target/, jen aplikaci ze serveru.<br>

## Porovnani WildFLY x JBoss EAP 

**WildFly** → upstream (community), používá se na vývoj a testy<br>
**JBoss EAP (Red Hat)** → downstream (enterprise), používá se v produkci<br>

<pre>
 Upstream (WildFly)
         +------------------+
         |  Nejnovější kód  |
         |  Nové funkce     |
         |  Komunita        |
         +------------------+
                   |
                   |  Red Hat bere kód,
                   |  stabilizuje, testuje,
                   v  vydává s podporou
         Downstream (JBoss EAP)
         +------------------+
         |  Stabilní verze  |
         |  Dlouhá podpora  |
         |  Enterprise use  |
         +------------------+
</pre>

+------------------+--------------------------+----------------------------+
|                  | WildFly (community)      | JBoss EAP (Red Hat)        |
+------------------+--------------------------+----------------------------+
| Plugin           | wildfly-maven-plugin     | jboss-as-maven-plugin      |
| Příkaz           | mvn wildfly:deploy       | mvn jboss-as:deploy        |
| Port mgmt.       | 9990 (management)        | 9999 (management - starší) |
| Artefakt         | helloworld-1.0.0.war     | helloworld-1.0.0.war       |
| Nasazení ručně   | cp target/*.war          | cp target/*.war            |
|                  |   -> standalone/deploy   |   -> standalone/deploy     |
| Podpora          | Komunita (upstream)      | Red Hat (enterprise)       |
+------------------+--------------------------+----------------------------+



+----------------+--------------------------+----------------------------+
| Fáze           | Testovací prostředí      | Produkční prostředí        |
+----------------+--------------------------+----------------------------+
| Server         | WildFly (community)      | JBoss EAP (Red Hat)        |
| Build          | mvn clean package        | (artefakt se NEMĚNÍ)       |
| Deploy plugin  | mvn wildfly:deploy       | mvn jboss-as:deploy        |
| Ruční deploy   | cp target/*.war          | cp target/*.war            |
| Účel           | Vývoj, testování, QA     | Stabilní provoz, podpora   |
+----------------+--------------------------+----------------------------+


        





## Co je to SNAPSHOT <br>
**SNAPSHOT** je jen součást názvu verze, žádná jiná speciální metadata ve WAR/JAR nejsou - tzn  je to jen jméno souboru a indikátor vývojové fáze<br>

# SNAPSHOT vs Finální verze

| Typ verze           | Příklad názvu souboru       | Co znamená                                    | Chování Mavenu/WildFly                           |
|--------------------|----------------------------|-----------------------------------------------|-------------------------------------------------|
| **SNAPSHOT**        | helloworld-1.0.0-SNAPSHOT.war | Vývojová/neustále se měnící verze           | Maven může při každém buildu aktualizovat, nasadit se může opakovaně, může být přepsána |
| **Finální verze**   | helloworld-1.0.0.war       | Stabilní, hotová verze                       | Neměnná, nasazuje se jako finální artefakt, nemění se |


Uplne presne takto

# Cesta build & deploy (SNAPSHOT vs Finální)
<pre>
src/ # zdrojové soubory (Java, JSP, HTML, web.xml)
└─ helloworld/
├─ src/main/java/
└─ src/main/webapp/
|
| mvn clean package
v
target/ # Maven build výstup
├─ helloworld-1.0.0-SNAPSHOT.war # vývojová verze (SNAPSHOT)
└─ helloworld-1.0.0.war # finální stabilní verze
|
| deploy (WildFly)
v
/opt/wildfly-XX/standalone/deployments/
├─ helloworld-1.0.0-SNAPSHOT.war → běží, může být přepsaná novým buildem
└─ helloworld-1.0.0.war → běží, stabilní, neměnná

</pre>


    

.

  	



















