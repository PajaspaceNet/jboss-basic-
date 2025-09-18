# Denní checklist pro aplikacího administrátora WildFly / JBoss

Tento dokument slouží jako rychlý denní přehled věcí, které by měl aplikací administrátor zkontrolovat, aby server a nasazené aplikace běžely správně.

---

## 1. Stav serveru
- [ ] Server běží (`ps aux | grep standalone` nebo `systemctl status wildfly`)  
- [ ] Přístup do management console funguje (WildFly: `http://host:9990`)  
- [ ] Kontrola logů serveru (`standalone/log/server.log`) – hledat chyby `ERROR` a varování `WARN`

---

## 2. Deploy aplikací
- [ ] Všechny WAR/JAR nasazeny a aktivní (`standalone/deployments/*.deployed`)  
- [ ] Ověření přístupu k aplikacím (např. `curl http://localhost:8080/helloworld`)  
- [ ] Kontrola verzí aplikací (SNAPSHOT vs finální verze)

---

## 3. Výkon a zdroje
- [ ] CPU, paměť a disk (`top`, `free -m`, `df -h`)  
- [ ] Heap a garbage collection – kontrola přes JMX nebo logy  
- [ ] Počet aktivních threadů a spojení (XNIO, datasources)

---

## 4. Datasources a připojení k DB
- [ ] Status všech datasources  
  ```bash
  /subsystem=datasources:read-resource(include-runtime=true)
