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

  	

















