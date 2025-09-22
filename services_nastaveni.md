## API SETTING - NASTAVENI Rozhrani API u sluzeb
 
 To, kde se definuje rozhraní v API (hlavně u webových služeb), záleží na tom,
 **jaký styl API** používáš a v jakém frameworku.
 
 Obecně to ale funguje takhle:

---

### 1. REST API (nejběžnější v Javě, Pythonu, atd.)

* **Rozhraní** se definuje pomocí **endpointů** – tedy URL cesty + HTTP metoda (`GET`, `POST`, `PUT`, `DELETE`).
* V Javě (např. Spring Boot) to děláš pomocí anotací v kontroleru:

```java
@RestController
@RequestMapping("/users")
public class UserController {

    @GetMapping("/{id}")
    public User getUser(@PathVariable int id) {
        // vrátí uživatele
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        // vytvoří nového uživatele
    }
}
```

👉 Tady `@RequestMapping("/users")` + `@GetMapping`, `@PostMapping` jsou vlastně definice **rozhraní služby**.

---

### 2. SOAP API (starší styl)

* Rozhraní se definuje v souboru **WSDL** (Web Services Description Language).
* Je to XML soubor, který přesně říká, jaké operace služba nabízí a jak vypadají jejich vstupy/výstupy.

---

### 3. OpenAPI / Swagger (moderní způsob dokumentace RESTu)

* Rozhraní se definuje v **OpenAPI specifikaci** (YAML nebo JSON soubor).
* Například:

```yaml
paths:
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: OK
```

👉 To pak vygeneruje přehlednou dokumentaci (Swagger UI) a často i klientský kód.

---

✅ Shrnutí:

* **Rozhraní API** = endpointy služby.
* Definuje se buď přímo v kódu (např. Spring Boot kontrolery), nebo v samostatném souboru (WSDL, OpenAPI).
* Dneska je nejběžnější **REST API + OpenAPI (Swagger)**, protože je to jasné a snadno se na tom domluví frontend s backendem.

---


