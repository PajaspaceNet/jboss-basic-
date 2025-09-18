## Checklist denni rutinka :-)
<table style="border-collapse: collapse; width: 100%;">
  <tr style="background-color: #f2f2f2;">
    <th style="border: 1px solid #ddd; padding: 8px;">Krok / Oblast</th>
    <th style="border: 1px solid #ddd; padding: 8px;">Co kontrolovat</th>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>1. Stav serveru</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Server běží (<code>ps aux | grep standalone</code> nebo <code>systemctl status wildfly</code>)</li>
        <li>Přístup do management console funguje (WildFly: <code>http://host:9990</code>)</li>
        <li>Kontrola logů serveru (<code>standalone/log/server.log</code>) – hledat chyby <code>ERROR</code> a varování <code>WARN</code></li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>2. Deploy aplikací</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Všechny WAR/JAR nasazeny a aktivní (<code>standalone/deployments/*.deployed</code>)</li>
        <li>Ověření přístupu k aplikacím (např. <code>curl http://localhost:8080/helloworld</code>)</li>
        <li>Kontrola verzí aplikací (SNAPSHOT vs finální verze)</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>3. Výkon a zdroje</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>CPU, paměť a disk (<code>top</code>, <code>free -m</code>, <code>df -h</code>)</li>
        <li>Heap a garbage collection – kontrola přes JMX nebo logy</li>
        <li>Počet aktivních threadů a spojení (XNIO, datasources)</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>4. Datasources a DB</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Status všech datasources:
          <pre>/subsystem=datasources:read-resource(include-runtime=true)</pre>
        </li>
        <li>Žádné visící připojení, žádné maxed out connections</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>5. Security / uživatelé</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Kontrola uživatelů a jejich rolí (<code>add-user.sh</code>)</li>
        <li>Platnost SSL certifikátů</li>
        <li>Role a práva správně nastaveny</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>6. Logy a alerty</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Projít <code>server.log</code> a <code>boot.log</code> pro chyby</li>
        <li>Kontrola GC logů, audit logů</li>
        <li>Aktivní alerty / notifikace fungují (email, Slack, monitoring)</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>7. Backup / konfigurace</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Zálohované všechny deploy artefakty</li>
        <li>Konfigurace serveru (<code>standalone/configuration/standalone.xml</code>) uložená ve verzovacím systému</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>8. Restart / patch</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      <ul>
        <li>Po patchi nebo změně konfigurace → server restartován</li>
        <li>Po restartu všechny aplikace startují správně</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td style="border: 1px solid #ddd; padding: 8px;"><b>Tip</b></td>
    <td style="border: 1px solid #ddd; padding: 8px;">
      Doporučené je mít skriptovaný denní check, který projde stav serveru, status deploymentů a zdraví databází.
    </td>
  </tr>
</table>
