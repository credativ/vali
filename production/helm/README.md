# ⚠️  DEPRECATED - Vali Helm Chart

This chart was moved to <https://github.com/grafana/helm-charts>.

## Prerequisites

Make sure you have Helm [installed](https://helm.sh/docs/using_helm/#installing-helm) and
[deployed](https://helm.sh/docs/using_helm/#installing-tiller) to your cluster. Then add
Vali's chart repository to Helm:

```bash
$ helm repo add vali https://credativ.github.io/vali/charts
```

You can update the chart repository by running:

```bash
$ helm repo update
```

## Deploy Vali and Promtail to your cluster

### Deploy with default config

```bash
$ helm upgrade --install vali vali/vali-stack
```

### Deploy in a custom namespace

```bash
$ helm upgrade --install vali --namespace=vali-stack vali/vali-stack
```

### Deploy with custom config

```bash
$ helm upgrade --install vali vali/vali-stack --set "key1=val1,key2=val2,..."
```

## Deploy Vali only

```bash
$ helm upgrade --install vali vali/vali
```

## Deploy Promtail only

We recommend Promtail to ship your logs to Vali as the configuration is very similar to Prometheus.
This allows you to ensure that labels for metrics and logs are equivalent by re-using the same `scrape_configs` and `relabeling` configuration.
When using Grafana having the same labels will allows you to pivot from Metrics to Logs verify easily by simply switching datasource.

To only install Promtail use the following command:

```bash
$ helm upgrade --install promtail vali/promtail --set "vali.serviceName=vali"
```

If you're not familiar with Prometheus and you don't want to migrate your current agent configs from the start,
 you can use our output plugins specified below.

## Deploy Vali and Fluent Bit to your cluster

```bash
$ helm upgrade --install vali vali/vali-stack \
    --set fluent-bit.enabled=true,promtail.enabled=false
```

## Deploy Fluent Bit only

```bash
$ helm upgrade --install fluent-bit vali/fluent-bit \
    --set "vali.serviceName=vali.svc.cluster.local"
```

## Deploy Vali and Filebeat and logstash to your cluster

```bash
$ helm upgrade --install vali vali/vali-stack \
    --set filebeat.enabled=true,logstash.enabled=true,promtail.enabled=false \
    --set vali.fullnameOverride=vali,logstash.fullnameOverride=logstash-vali
```

## Deploy Grafana to your cluster

To install Grafana on your cluster with helm, use the following command:

```bash
# with Helm 2
$ helm install stable/grafana -n vali-grafana --namespace <YOUR-NAMESPACE>

# with Helm 3
$ helm install vali-grafana stable/grafana -n <YOUR-NAMESPACE>
```

> The chart vali-stack contains a pre-configured Grafana, simply use `--set grafana.enabled=true`

To get the admin password for the Grafana pod, run the following command:

```bash
$ kubectl get secret --namespace <YOUR-NAMESPACE> vali-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To access the Grafana UI, run the following command:

```bash
$ kubectl port-forward --namespace <YOUR-NAMESPACE> service/vali-grafana 3000:80
```

Navigate to http://localhost:3000 and login with `admin` and the password output above.
Then follow the [instructions for adding the vali datasource](/docs/getting-started/grafana.md), using the URL `http://vali:3100/`.

## Run Vali behind https ingress

If Vali and Promtail are deployed on different clusters you can add an Ingress in front of Vali.
By adding a certificate you create an https endpoint. For extra security enable basic authentication on the Ingress.

In Promtail set the following values to communicate with https and basic auth

```
vali:
  serviceScheme: https
  user: user
  password: pass
```

Sample helm template for ingress:
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
annotations:
    kubernetes.io/ingress.class: {{ .Values.ingress.class }}
    ingress.kubernetes.io/auth-type: "basic"
    ingress.kubernetes.io/auth-secret: {{ .Values.ingress.basic.secret }}
name: vali
spec:
rules:
- host: {{ .Values.ingress.host }}
    http:
    paths:
    - backend:
        serviceName: vali
        servicePort: 3100
tls:
- secretName: {{ .Values.ingress.cert }}
    hosts:
    - {{ .Values.ingress.host }}
```

## Run promtail with syslog support

In order to receive and process syslog message into promtail, the following changes will be necessary:

* Review the [promtail syslog-receiver configuration documentation](/docs/clients/promtail/scraping.md#syslog-receiver)

* Configure the promtail helm chart with the syslog configuration added to the `extraScrapeConfigs` section and associated service definition to listen for syslog messages. For example:

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

## Run promtail with systemd-journal support

In order to receive and process syslog message into promtail, the following changes will be necessary:

* Review the [promtail systemd-journal configuration documentation](/docs/clients/promtail/scraping.md#journal-scraping-linux-only)

* Configure the promtail helm chart with the systemd-journal configuration added to the `extraScrapeConfigs` section and volume mounts for the promtail pods to access the log files. For example:

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

# Mount journal directory into promtail pods
extraVolumes:
  - name: journal
    hostPath:
      path: /var/log/journal

extraVolumeMounts:
  - name: journal
    mountPath: /var/log/journal
    readOnly: true
```

## How to contribute

After adding your new feature to the appropriate chart, you can build and deploy it locally to test:

```bash
$ make helm
$ helm upgrade --install vali ./vali-stack-*.tgz
```

After verifying your changes, you need to bump the chart version following [semantic versioning](https://semver.org) rules.
For example, if you update the vali chart, you need to bump the versions as follows:

- Update version vali/Chart.yaml
- Update version vali-stack/Chart.yaml

You can use the `make helm-debug` to test and print out all chart templates. If you want to install helm (tiller) in your cluster use `make helm-install`, to install the current build in your Kubernetes cluster run `make helm-upgrade`.
