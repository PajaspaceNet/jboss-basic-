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

## JAK SE NASAZUJE V JBOSSU

•	V WildFly / JBoss můžeš aplikaci nasadit třemi způsoby:
1.	Kopírováním .war/.ear do složky deployments/ – WildFly ji automaticky nasadí.
2.	Přes management konzoli – nahrát .war a kliknout Enable.
3.	Přes CLI (jboss-cli.sh deploy) – příkazový  a ideální pro skripty nebo CI/CD.



