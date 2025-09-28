## LDAP

👉 LDAP = Lightweight Directory Access Protocol<br>
(v překladu: lehký protokol pro přístup k adresářovým službám).<br>

📌 Jednoduše řečeno:<br>
**LDAP** je protokol, kterým se přistupuje k tzv. adresářové službě – databázi, <br>
kde jsou uložení uživatelé, skupiny, hesla, přístupová práva, počítače apod.<br>

<pre>
+-----------+       login (jméno+heslo)       +-------------+       ověření/role       +--------------------+
| Uživatel  | -----------------------------> |   JBoss      | ---------------------> |   LDAP / AD        |
|           |                                |   Server     | <--------------------- |  adresářová služba |
+-----------+       přístup k aplikaci       +-------------+     potvrzení/přístup   +--------------------+
</pre>



Příklad z praxe:

Firma má stovky zaměstnanců.<br>

Každý má uživatelské jméno, heslo, oddělení, roli.<br>

Tyto údaje se ukládají do centrální adresářové služby (typicky Microsoft Active Directory).<br>

Aplikace nebo servery (třeba i JBoss) pak přes LDAP ověřují, jestli je uživatel oprávněný se přihlásit, a jaké má role.<br>

## Proč je to důležité:

Aplikace nebo servery (třeba i JBoss) pak přes LDAP ověřují, <br>
jestli je uživatel oprávněný se přihlásit, a jaké má role.<br>
Centralizace: správa uživatelů je na jednom místě, ne v každé aplikaci zvlášť.<br>

Bezpečnost: jednotné heslo, role, rychlé zablokování účtu.<br>

Integrace: spousta systémů (mail, databáze, intranet, JBoss) se umí napojit na LDAP.<br>

💡 V kontextu JBossu:<br>
Když nasadíš aplikaci a chceš, aby se uživatelé přihlašovali<br> 
firemním jménem a heslem, nastavíš v JBossu security domain nebo<br>
Elytron, který se napojí na LDAP/Active Directory<br>
