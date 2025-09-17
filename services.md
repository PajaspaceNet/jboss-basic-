
# Meetingový tahák: REST vs Message Broker

## REST (synchronní)
<pre>
Service A --HTTP--> Service B
Service A <--HTTP-- Service B
</pre>

## Message Broker (asynchronní)
<pre>
Service A --msg--> Broker --> Service B
(Service A pokračuje hned)
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

## Par faktu
- „REST používáme pro okamžité operace a broker pro asynchronní zpracování.“
- „Broker nám zajišťuje nezávislost služeb a odolnost vůči chybám.“
- „Služby jsou oddělené, komunikují přes fronty a eventy.“
