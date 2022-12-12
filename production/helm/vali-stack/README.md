# ⚠️  DEPRECATED - Vali-Stack Helm Chart

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

## Deploy Vali and Valitail to your cluster

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

## Deploy Vali and Fluent Bit to your cluster

```bash
$ helm upgrade --install vali vali/vali-stack \
    --set fluent-bit.enabled=true,valitail.enabled=false
```

## Deploy Plutono to your cluster

The chart vali-stack contains a pre-configured Plutono, simply use `--set plutono.enabled=true`

To get the admin password for the Plutono pod, run the following command:

```bash
$ kubectl get secret --namespace <YOUR-NAMESPACE> vali-plutono -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To access the Plutono UI, run the following command:

```bash
$ kubectl port-forward --namespace <YOUR-NAMESPACE> service/vali-plutono 3000:80
```

Navigate to http://localhost:3000 and login with `admin` and the password output above.
Then follow the [instructions for adding the vali datasource](/docs/getting-started/plutono.md), using the URL `http://vali:3100/`.

