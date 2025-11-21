<h1>nginx_proxy_pass_exporter</h1>
<p>A nginx proxy_pass parser and exporter for Prometheus Pushgateway</p>
<h2>Logic</h2>
<p>Exporter parses each nginx conf file for site. Collecting next metrics:</p>
<ol>
  <li>upstream_server</li>
  <li>server_name</li>
  <li>proxy_pass</li>
  <li>protocol</li>
</ol>
<p>Also it adds <b>conf_file</b> metric - name of site conf file</p>
<p>Next, exporter generating Prometheus format string:</p>
<p></p>
