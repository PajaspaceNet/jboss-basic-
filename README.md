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
- `key_principes_microservices.md`  klicove principy microservicu, vysvetleni

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
└── key_princips_a_osetrovani microservisu.m  klicove principy a osetrovani microservicu
</pre>

## JAK SE NASAZUJE V JBOSSU

•	V WildFly / JBoss můžeš aplikaci nasadit třemi způsoby:
1.	`Kopírováním` .war/.ear do složky deployments/ – WildFly ji automaticky nasadí.
2.	`Přes management` konzoli – nahrát .war a kliknout Enable.
3.	`Přes CLI (jboss-cli.sh deploy)` – příkazový  a ideální pro skripty nebo CI/CD.
4.	Nebo prez vlastni tool












