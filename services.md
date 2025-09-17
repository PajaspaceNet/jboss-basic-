# Services v microeservicech

## Jeste nez zacnem co se casto plete a hodne casto se to vytahuje 

**Linux služby** = OS-level, demonické procesy<br>
**Mikroservisy** = samostatné, nezávislé služby na síti, často v kontejnerech<br>


| Vlastnost      | Linux služby (OS)          | Mikroservisy                           |
| -------------- | -------------------------- | -------------------------------------- |
| Izolace        | Společný OS, menší izolace | Každá služba izolovaná (container)     |
| Komunikace     | IPC, sockety, soubory      | HTTP, gRPC, message broker             |
| Deployment     | OS-level start/stop        | Container/orchestrátor, CI/CD          |
| Škálovatelnost | Omezená                    | Velmi flexibilní, horizontální scaling |
| Databáze       | Sdílené nebo systémové     | Každá služba vlastní databázi          |

* Detailni vysvetleni uplne na konci ... <br>
- ted vzhuru do Microservicu


### Tipy zprav ktere se prenaseji 


**Eventy →** „co se stalo“ (asynchronní) ,asynchronní, loosely coupled, pro informování ostatních služeb

**Command →** „udělej tohle“ (asynchronní nebo synchronní),instrukce, někdy asynchronní, když služba má vykonat konkrétní akci

**Request/Response** → „dej mi data“ (synchronní) ,když potřebuješ okamžitou odpověď

**Event-sourced data** → historie a audit (persistentní, někdy dlouhodobě uchované),

**Většinou REST** volání dělá request/response, **Broker** řeší **eventy a commandy**, a **kombinací** toho se staví škálovatelné mikroservisy.

 

# Mikroservisy – Typy zpráv

| Typ zprávy                    | Popis / Kdy použít                                            | Příklad                                                  |
| ----------------------------- | ------------------------------------------------------------- | -------------------------------------------------------- |
| Event (událost)               | Notifikace, že se něco stalo; asynchronní                     | "Nový uživatel se zaregistroval", "Objednávka dokončena" |
| Command (příkaz)              | Instrukce, aby služba něco provedla; asynchronní i synchronní | "Vytvoř fakturu pro tuto objednávku", "Odešli email"     |
| Request/Response              | Žádost o data nebo výsledek; synchronní                       | "Dej mi informace o uživateli podle ID"                  |
| Event-sourced data / snapshot | Historie změn, audit; persistentní, dlouhodobé                | "Změny stavu objednávky", "Historie inventáře"           |
| Notification                  | Jednosměrné zprávy pro informování služeb nebo uživatelů      | "Nová zpráva v chatu", "Systémová notifikace"            |
| Heartbeat / Health check      | Stav služby, udržuje orchestrátory informované                | "Jsem online", "Kontrola dostupnosti služby"             |

## Tipy k použití

* **Eventy →** asynchronní, loosely coupled, pro informování ostatních služeb
* **Command →** instrukce, někdy asynchronní, když služba má vykonat konkrétní akci
* **Request/Response →** synchronní, když potřebuješ okamžitou odpověď
* **Event-sourced / snapshot →** historie a audit, CQRS, reporting
* **Notification →** jednosměrné zprávy, ideální pro UI nebo uživatelské upozornění
* **Heartbeat →** monitoring dostupnosti služeb







# REST vs Message Broker

* REST → volání a čekání na odpověď.
* Broker → pošlu zprávu a pokračuji, zpracování proběhne později.

## REST (synchronní)
<pre>
Service A --HTTP--> Service B
Service A <--HTTP-- Service B
</pre>

<pre>
+-----------+        HTTP Request         +-----------+
| Service A | -------------------------> | Service B |
| (caller)  | <------------------------- | (responder) |
+-----------+        HTTP Response       +-----------+
</pre>

- Service A čeká, až Service B odpoví.
- Pokud Service B není dostupná, volání selže.


## Message Broker (asynchronní)
<pre>
Service A --msg--> Broker --> Service B
(Service A pokračuje hned)
</pre>
<pre>
+-----------+        Publish Message      +------------+
| Service A | -------------------------> |  Broker    |
| (producer)|                               | (queue)    |
+-----------+                               +------------+
                                               |
                                               v
                                         +-----------+
                                         | Service B |
                                         | (consumer)|
                                         +-----------+
</pre>
- Service A nečeká na zpracování – broker doručí zprávu, až Service B zpracuje.
- Service B může být offline – broker zprávu uloží a doručí později.

  Detailneji
  <pre>
  Producer (Service A)
        |
        |  Pošle zprávu (nečeká)
        v
  +-----------------+
  |   Broker        |
  |  (Fronta / RAM) |
  |  Zpráva aktivní |
  +-----------------+
        |
        |  Consumer si převezme zprávu
        v
Consumer (Service B/C)
        |
        |  Zpráva zpracována → broker označí jako doručená
        v
  +-----------------+
  |   Broker        |
  |  Zpráva odstraněna|
  +-----------------+
</pre>



## Tabulka vlastností

| Vlastnost | REST | Broker |
|-----------|------|--------|
| Komunikace | čeká na odpověď | nečeká, doručí později |
| Typ volání | HTTP GET/POST | message queue / event |
| Odolnost | nízká | vysoká |
| Decoupling | nízké | vysoké |
| Příklad | Service A → Service B | Service A → Broker → Service B |
| Použití | CRUD, okamžitá odpověď | notifikace, dávkové úlohy |

**Decoupling** = služby jsou nezávislé → změny nebo pád jedné služby neovlivní ostatní.<br>
**Coupling** = pevná závislost → všechny části jsou propojené a méně flexibilní.

| Pojem          | Význam                                                                | Proč je důležité                          | Příklad v mikroslužbách                                                             |
| -------------- | --------------------------------------------------------------------- | ----------------------------------------- | ----------------------------------------------------------------------------------- |
| **Decoupling** | Oddělení/nepřímá závislost mezi částmi systému (službami nebo moduly) | Zvyšuje odolnost, škálovatelnost a údržbu | Služba A posílá zprávu do brokera → služba B ji zpracuje, A nemusí čekat na odpověď |
| **Coupling**   | Silná závislost – změna jedné části ovlivní ostatní                   | Snižuje flexibilitu, zvyšuje riziko chyb  | Služba A přímo volá API služby B a čeká na odpověď; pokud B spadne, A nefunguje     |


## Par faktu
- „REST používáme pro okamžité operace a broker pro asynchronní zpracování.“
- „Broker nám zajišťuje nezávislost služeb a odolnost vůči chybám.“
- „Služby jsou oddělené, komunikují přes fronty a eventy.“


## Kde Broker drzi zpravy 

* Uchovávání zpráv v brokeru
* Interní úložiště brokera

* Broker má vlastní úložiště – fronty, logy, paměť + disk.
* Není to databáze – slouží jen k doručení zpráv mezi službami.
* Trvalé ukládání dat patří do databází, broker je spíš „poštovní schránka“ mezi službami. 

### Každý message broker má svůj vlastní mechanismus pro uchování zpráv.

Např.:

**RabbitMQ** – zprávy se ukládají do front (queues), které jsou v paměti a/nebo na disku.

**Kafka** – zprávy se zapisují do logů na disku, každá zpráva má offset a může být uchována delší dobu.

Paměť vs. Disk

**Lehké zprávy** často zůstávají v paměti (rychlejší doručení).

Pro spolehlivost se zprávy zapisují i na disk – pokud by broker spadl, po restartu se doručení obnoví.<br>

**Dočasné vs. trvalé uložení**

Broker zprávu typicky drží jen dokud není doručena všem odběratelům.<br>
Není to místo pro dlouhodobé ukládání dat – na to jsou databáze.<br>
<br>
Některé brokery (např. Kafka) umožňují zprávy uchovávat dlouhodobě, ale stále primárně pro streamy / eventy, ne jako klasickou databázi.


# Message Brokers typy 

* Jednodušší: RabbitMQ → snadné pochopení a nasazení.
* Velké datové toky: Kafka → standard pro streamy.
* Cloud-native / serverless: SQS nebo NATS → rychlé, spravované.

| Broker         | Typ                   | Použití                                     | Výhody                                                | Nevýhody                         |
| -------------- | --------------------- | ------------------------------------------- | ----------------------------------------------------- | -------------------------------- |
| RabbitMQ       | Message Queue (AMQP)  | Klasické fronty, mikroservisy               | Jednoduché, spolehlivé, routing, persistentní fronty  | Menší výkon pro high-throughput  |
| Apache Kafka   | Event streaming / log | Real-time streaming, event-driven arch.     | Vysoký výkon, škálovatelné, zprávy lze uchovat dlouho | Složitější nasazení, správa      |
| ActiveMQ       | Message Queue (JMS)   | Enterprise aplikace, integrace systémů      | Podpora JMS, spolehlivé doručení, persistentní        | Starší technologie, méně moderní |
| Amazon SQS/SNS | Cloud queue / pub-sub | Cloudové aplikace, serverless, mikroservisy | Spravované, škálovatelné, jednoduché nasazení         | Závislost na AWS, náklady        |
| NATS           | Lightweight pub-sub   | Rychlé messagingy, IoT, mikroservisy        | Jednoduchý, rychlý, nízká latence, cloud-native       | Menší ekosystém a funkcionality  |

---


## Detailni rozdeleni service v OS Linux a service v Microservicech <br>

## Služby v Linuxu (OS level)

Co to je: procesy, démoni, služby operačního systému<br>

**Příklad:** <br>

systemd služby (např. nginx.service, sshd.service)<br>
Cron jobs, databázové démony (postgresql.service)<br>
Správa: pomocí systemctl start/stop/status, service<br>

**PřCharakter:** Př<br>

Monolitický kontext OS – běží jako jeden proces nebo skupina procesů<br>
Komunikace většinou přes sockety, soubory, IPC<br>

2️⃣ **Služby v mikroservisní architektuře<br>**

**Co to je**: samostatné aplikace/služby, které komunikují přes síť (HTTP, gRPC, message broker)<br>

**Příklad:<br>**

UserService → správa uživatelů<br>
OrderService → správa objednávek<br>

**NotificationService → posílá emaily/push notifikace<br>**

**Správa:<br>**

Docker kontejnery (docker run, docker-compose)
Orchestrátory (Kubernetes, OpenShift)

**Charakter**:

**Každá služba je nezávislá, má vlastní databázi nebo zdroje<br>**

Komunikace je většinou REST, gRPC, message broker<br>

**Lze škálovat a deployovat samostatně<br>**





