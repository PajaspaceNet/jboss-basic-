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



| Zkratka | Název (EN)          | Význam / k čemu slouží                    | Příklad hodnoty                         |
| ------- | ------------------- | ----------------------------------------- | --------------------------------------- |
| **DC**  | Domain Component    | Doménová komponenta (část názvu domény)   | `DC=firma`, `DC=cz`                     |
| **OU**  | Organizational Unit | Organizační jednotka (jako složka)        | `OU=People`, `OU=Groups`                |
| **CN**  | Common Name         | Obecné jméno objektu (uživatel, skupina…) | `CN=Jan Novak`                          |
| **DN**  | Distinguished Name  | Celá unikátní cesta k objektu             | `CN=Jan Novak,OU=People,DC=firma,DC=cz` |


## Základní pojmy

**DC (Domain Component)** → doména, např. DC=firma,DC=cz<br>
**OU (Organizational Unit)** → organizační jednotka, např. OU=People<br>
**CN (Common Name)** → běžné jméno, např. CN=Jan Novak<br>


Jak to funguje:

Active Directory / LDAP je vlastně speciální databáze.<br>
Data (uživatelská jména, hesla – uložená jako hashe, role, skupiny…) jsou uložená na disku serveru, který běží jako adresářová služba.<br>
Když aplikace (např. JBoss) ověřuje uživatele, pošle dotaz na LDAP server → ten sáhne do databáze a vrátí odpověď.<br>

Aby to bylo rychlé, server si některé věci může cacheovat v paměti (RAM), ale primárně je to uložené na disku.<br>

Údaje nejsou jen v paměti – jsou perzistentně uložené na serveru v adresářové databázi.<br> 
Paměť se používá jen pro zrychlení přístupu.<br>



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

