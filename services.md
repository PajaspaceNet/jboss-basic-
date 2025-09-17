
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
