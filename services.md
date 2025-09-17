
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



## Tabulka vlastností

| Vlastnost | REST | Broker |
|-----------|------|--------|
| Komunikace | čeká na odpověď | nečeká, doručí později |
| Typ volání | HTTP GET/POST | message queue / event |
| Odolnost | nízká | vysoká |
| Decoupling | nízké | vysoké |
| Příklad | Service A → Service B | Service A → Broker → Service B |
| Použití | CRUD, okamžitá odpověď | notifikace, dávkové úlohy |

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



