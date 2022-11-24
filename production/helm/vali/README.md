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

## Deploy Vali only

```bash
$ helm upgrade --install vali vali/vali
```

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

## Use Vali Alerting

You can add your own alerting rules with `alerting_groups` in `values.yaml`. This will create a ConfigMap with your rules and additional volumes and mounts for Vali.

This does **not** enable the Vali `ruler` component which does the evaluation of your rules. The `values.yaml` file does contain a simple example. For more details take a look at the official [alerting docs](https://grafana.com/docs/loki/latest/alerting/).