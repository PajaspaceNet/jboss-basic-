## Microservices - Klíčové principy



| Oblast                                  | Co je důležité                                                           | Proč je to podstatné                               |
| --------------------------------------- | ------------------------------------------------------------------------ | -------------------------------------------------- |
| Service discovery                       | Jak služby nacházejí jedna druhou (např. Consul, Eureka, Kubernetes DNS) | Služby se navzájem najdou bez pevného URL          |
| Load balancing                          | Rozdělování požadavků mezi více instancí služby                          | Škálovatelnost a dostupnost                        |
| Fault tolerance / resiliency            | Jak systém zvládá pády a chyby (circuit breaker, retries, fallback)      | Zvyšuje odolnost systému                           |
| API Gateway                             | Jednotný vstup do mikroservis (např. NGINX, Kong, Istio)                 | Zjednodušuje autentizaci, rate limiting, routing   |
| Configuration management                | Centralizovaná konfigurace služeb (Spring Cloud Config, Consul)          | Snadná změna konfigurace bez restartu              |
| Security / Auth                         | Ověření a autorizace mezi službami (JWT, OAuth2)                         | Bezpečný přístup k datům a službám                 |
| Logging / Tracing                       | Centralizované logy, distributed tracing (ELK, Jaeger)                   | Snadné debugování a sledování requestů přes služby |
| Data management / CQRS / Event sourcing | Oddělení čtení a zápisu, práce s eventy                                  | Lepší škálovatelnost, odolnost a konzistence dat   |


# Jak ošetřit / spravovat mikroservisy

| Oblast                   | Popis / Tipy                                                                                                     |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| Komunikace mezi službami | REST, gRPC, message brokery, eventy → vše musí fungovat spolehlivě; řešit timeouty, retry, circuit breaker       |
| Distribuovaná data       | Každá služba má často vlastní databázi → problém s konzistencí; použít eventual consistency, CQRS                |
| Monitoring a tracing     | Více služeb → více logů → centralizovat (ELK, Jaeger, Prometheus); jinak chyby mezi službami tě mohou „roztrhat“ |
| Deployment a orchestrace | Docker, Kubernetes, CI/CD pipeline → každý release je komplexnější než monolit                                   |
| Odolnost systému         | Pokud jedna služba spadne, mít fallback a health checky; jinak může degradovat celý systém                       |
| Debugging a testování    | Tracing requestů přes služby je potřeba, jinak tě chyby zmátou                                                   |



