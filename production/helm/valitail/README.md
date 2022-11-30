# ⚠️  DEPRECATED - Valitail Helm Chart

This chart was moved to <https://github.com/grafana/helm-charts>.

## Deploy Valitail only

```bash
$ helm upgrade --install valitail vali/valitail --set "vali.serviceName=vali"
```

## Run Vali behind https ingress

If Vali and Valitail are deployed on different clusters you can add an Ingress in front of Vali.
By adding a certificate you create an https endpoint. For extra security enable basic authentication on the Ingress.

In Valitail set the following values to communicate with https and basic auth

```
vali:
  serviceScheme: https
  user: user
  password: pass
```

## Run valitail with syslog support

In order to receive and process syslog message into valitail, the following changes will be necessary:

* Review the [valitail syslog-receiver configuration documentation](/docs/clients/valitail/scraping.md#syslog-receiver)

* Configure the valitail helm chart with the syslog configuration added to the `extraScrapeConfigs` section and associated service definition to listen for syslog messages. For example:

```yaml
extraScrapeConfigs:
  - job_name: syslog
    syslog:
      listen_address: 0.0.0.0:1514
      labels:
        job: "syslog"
  relabel_configs:
    - source_labels: ['__syslog_message_hostname']
      target_label: 'host'
syslogService:
  enabled: true
  type: LoadBalancer
  port: 1514
```

## Run valitail with systemd-journal support

In order to receive and process syslog message into valitail, the following changes will be necessary:

* Review the [valitail systemd-journal configuration documentation](/docs/clients/valitail/scraping.md#journal-scraping-linux-only)

* Configure the valitail helm chart with the systemd-journal configuration added to the `extraScrapeConfigs` section and volume mounts for the valitail pods to access the log files. For example:

```yaml
# Add additional scrape config
extraScrapeConfigs:
  - job_name: journal
    journal:
      path: /var/log/journal
      max_age: 12h
      labels:
        job: systemd-journal
    relabel_configs:
      - source_labels: ['__journal__systemd_unit']
        target_label: 'unit'
      - source_labels: ['__journal__hostname']
        target_label: 'hostname'

# Mount journal directory into valitail pods
extraVolumes:
  - name: journal
    hostPath:
      path: /var/log/journal

extraVolumeMounts:
  - name: journal
    mountPath: /var/log/journal
    readOnly: true
```

