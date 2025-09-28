# JBoss/WildFly Basics

Tento repozitář slouží k nácviku a demonstraci základních operací s WildFly/JBoss:

- Instalace serveru 
- Konfigurace uživatele a portů
- Deploy testovací Java aplikace (`demo-app.war`)
- Deploy ap;ikaci obecne na Jboss/Wildfly
- Správa aplikací přes CLI a konzoli
 - Microservices
 - Daily Checklist Aplikacniho Admina
 - Common Issues Jboss
   
## Struktura

- `installation/` – skripty a návody pro instalaci
- `deployment/` – testovací aplikace a deploy skripty
- `configuration/` – konfigurace uživatelů a serveru
- `services.md`  #  synchroni a asynchroni sluzby , vysvetleni
- `key_princips_a_osetrovani microservisu.md`  klicove principy a sprava microservicu
- `checklist-applic-admin.md` - checklist a denni kontroly
- `common issues` - bezne chyby a reseni

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
└── README.md # instalace jak instalovat ,HOWTOs
└── services.md  #  synchroni a asynchroni sluzby
└── key_princips_a_osetrovani microservisu.md # klicove principy a osetrovani microservicu
└──   checklist-applic-admin.md # denni check list application admina
└──     common-issues.md - bezne chyby a jejich obecne reseni 
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
      
  	/opt/wildfly-XX/bin/jboss-cli.sh --connect --command="undeploy helloworld.war"
    

   PREHLEDNE V TABULCE <br>

<table style="border-collapse: collapse; width: 100%;">
  <tr style="background-color: #f2f2f2;">
    <th style="border: 1px solid #ddd; padding: 8px;">Krok</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Co se děje</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Kde/Co vzniká</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Jak se aplikuje/odstraňuje</th>
  </tr>
  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>1. Zdrojové soubory</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Píšeš Java třídy, JSP, HTML, CSS, konfigurace (<code>web.xml</code>)</td>
    <td style="border: 1px solid #ddd; padding: 8px;"><code>src/main/java/</code>, <code>src/main/webapp/</code>, <code>WEB-INF/</code></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Výchozí obsah projektu, zatím není spustitelné</td>
  </tr>
  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>2. Maven build</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Spuštění <code>mvn clean package</code></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Maven zkompiluje třídy, zabalí do WAR a uloží do <code>target/</code></td>
    <td style="border: 1px solid #ddd; padding: 8px;"><code>target/helloworld.war</code> – hotová aplikace připravená k nasazení</td>
  </tr>
  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>3. Deploy (nasazení)</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Aplikace je nasazena na WildFly</td>
    <td style="border: 1px solid #ddd; padding: 8px;">WAR soubor je rozbalen WildFly v runtime (<code>standalone/deployments/</code>)</td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <b>Ručně:</b> <code>cp target/helloworld.war /opt/wildfly-XX/standalone/deployments/</code><br/>
      <b>Maven:</b> <code>mvn wildfly:deploy</code><br/>
      <b>CLI:</b> <code>jboss-cli.sh --connect --command="deploy /cesta/k/helloworld.war"</code>
    </td>
  </tr>
  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>4. Běh aplikace</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">WildFly spouští aplikaci, dostupná přes prohlížeč</td>
    <td style="border: 1px solid #ddd; padding: 8px;">běží v serveru, nezávisle na <code>target/</code></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Otevřeš např.: <code>http://localhost:8080/helloworld</code></td>
  </tr>
  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>5. Odstranění (undeploy)</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">Aplikace je odstraněna ze serveru</td>
    <td style="border: 1px solid #ddd; padding: 8px;">WAR může zůstat v <code>target/</code>, ale server ji odstraní z deployments</td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <b>Ručně:</b> <code>rm /opt/wildfly-XX/standalone/deployments/helloworld.war</code><br/>
      <b>Maven:</b> <code>mvn wildfly:undeploy</code><br/>
      <b>CLI:</b> <code>jboss-cli.sh --connect --command="undeploy helloworld.war"</code>
    </td>
  </tr>
</table>


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

<pre>
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
</pre>

<pre>
+----------------+--------------------------+----------------------------+
| Fáze           | Testovací prostředí      | Produkční prostředí        |
+----------------+--------------------------+----------------------------+
| Server         | WildFly (community)      | JBoss EAP (Red Hat)        |
| Build          | mvn clean package        | (artefakt se NEMĚNÍ)       |
| Deploy plugin  | mvn wildfly:deploy       | mvn jboss-as:deploy        |
| Ruční deploy   | cp target/*.war          | cp target/*.war            |
| Účel           | Vývoj, testování, QA     | Stabilní provoz, podpora   |
+----------------+--------------------------+----------------------------+
</pre>

        





## Co je to SNAPSHOT <br>
**SNAPSHOT** je jen součást názvu verze, žádná jiná speciální metadata ve WAR/JAR nejsou - tzn  je to jen jméno souboru a indikátor vývojové fáze<br>

# SNAPSHOT vs Finální verze

| Typ verze           | Příklad názvu souboru       | Co znamená                                    | Chování Mavenu/WildFly                           |
|--------------------|----------------------------|-----------------------------------------------|-------------------------------------------------|
| **SNAPSHOT**        | helloworld-1.0.0-SNAPSHOT.war | Vývojová/neustále se měnící verze           | Maven může při každém buildu aktualizovat, nasadit se může opakovaně, může být přepsána |
| **Finální verze**   | helloworld-1.0.0.war       | Stabilní, hotová verze                       | Neměnná, nasazuje se jako finální artefakt, nemění se |


</pre>



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

## Zaverecne zjednoduseni prubeh od kodu az po nasazeni na server v produkci

<table style="border-collapse: collapse; width: 100%;">
  <tr style="background-color: #f2f2f2;">
    <th style="border: 1px solid #ddd; padding: 8px;">Krok / Fáze</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Testovací prostředí</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Produkční prostředí</th>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>1. Zdrojové soubory</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      src/main/java/<br/>
      src/main/webapp/<br/>
      WEB-INF/<br/>
      Píšeš kód, JSP, HTML
    </td>
    <td style="border: 1px solid #ddd; padding: 8px;">stejné jako v testu</td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>2. Build</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      mvn clean package<br/>
      Vytvoří target/*.war<br/>
      SNAPSHOT pro testy
    </td>
    <td style="border: 1px solid #ddd; padding: 8px;">Build už proběhl (stejný .war), Finální verze pro produkci</td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>3. Deploy</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      WildFly<br/>
      Plugin: wildfly-maven-plugin<br/>
      Příkaz: mvn wildfly:deploy<br/>
      Ručně: cp target/*.war -> standalone/deploy<br/>
      Port: 9990
    </td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      JBoss EAP<br/>
      Plugin: jboss-as-maven-plugin<br/>
      Příkaz: mvn jboss-as:deploy<br/>
      Ručně: cp target/*.war -> standalone/deploy<br/>
      Port: 9999 (management)
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>4. Běh aplikace</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      Otevření v prohlížeči<br/>
      http://localhost:8080
    </td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      Otevření v produkčním prohlížeči<br/>
      http://prod-server:8080
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>5. Odstranění (undeploy)</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      mvn wildfly:undeploy<br/>
      nebo rm standalone/deployments/*.war
    </td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      mvn jboss-as:undeploy<br/>
      nebo rm standalone/deployments/*.war
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>6. Poznámky</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">SNAPSHOT = vývojová verze, může se přepsat</td>
    <td style="border: 1px solid #ddd; padding: 8px;">Finální verze, stabilní artefakt</td>
  </tr>
</table>



    

.

  	

























