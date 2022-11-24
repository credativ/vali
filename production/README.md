# Running Vali

Currently there are five ways to try out Vali, in order from easier to hardest:

- [Grafana Cloud: Hosted Logs](#grafana-cloud-logs)
- [Run Vali locally with Docker](#run-locally-using-docker)
- [Use Helm to deploy on Kubernetes](#using-helm-to-deploy-on-kubernetes)
- [Build Vali from source](#build-and-run-from-source)
- [Get inspired by our production setup](#get-inspired-by-our-production-setup)

For the various ways to run `promtail`, the tailing agent, see our [Promtail documentation](../docs/clients/promtail/README.md).

## Grafana Cloud: Hosted Logs

Grafana is offering hosted Vali as part of our broader Grafana Cloud platform. Learn more at [grafana.com/loki](https://grafana.com/oss/vali/#products-and-services).

## Run locally using Docker

The Docker images for [Vali](https://hub.docker.com/r/credativ/vali/) and [Promtail](https://hub.docker.com/r/grafana/promtail/) are available on DockerHub.

To test locally, we recommend using the `docker-compose.yaml` file in this directory. Docker starts containers for Promtail, Vali, and Grafana.

1. Either `git clone` this repository locally and `cd vali/production`, or download a copy of the [docker-compose.yaml](docker-compose.yaml) locally.

1. Ensure you have the most up-to-date Docker container images:

   ```bash
   docker-compose pull
   ```

1. Run the stack on your local Docker:

   ```bash
   docker-compose up
   ```

1. Grafana should now be available at http://localhost:3000/. Log in with `admin` / `admin` and follow the [steps for configuring the datasource in Grafana](../docs/getting-started/grafana.md), using `http://vali:3100` for the URL field.

**Note:** When running locally, Promtail starts before Vali is ready. This can lead to the error message "Data source connected, but no labels received." After a couple seconds, Promtail will forward all newly created log messages correctly.
Until this is fixed we recommend [building and running from source](#build-and-run-from-source).

For instructions on how to query Vali, see [our usage docs](https://grafana.com/docs/loki/latest/logql/).

To deploy a cluster of vali locally, please refer to this [doc](./docker/)

## Using Helm to deploy on Kubernetes

There is a [Helm chart](helm) to deploy Vali and Promtail to Kubernetes.

## Build and run from source

Frist, see the [build from source](../README.md) section of the root readme.

Once Promtail is built, to run Promtail, use the following command:

```bash
$ ./promtail -config.file=./cmd/promtail/promtail-local-config.yaml
...
```

Grafana is Vali's UI. To query your logs you need to start Grafana as well:

```bash
$ docker run -ti -p 3000:3000 grafana/grafana:master
```

Grafana should now be available at http://localhost:3000/. Follow the [steps for configuring the datasource in Grafana](https://grafana.com/docs/loki/latest/getting-started/grafana/) and set the URL field to `http://host.docker.internal:3100`.

For instructions on how to use Vali, see [our usage docs](https://grafana.com/docs/loki/latest/logql/).

## Get inspired by our production setup

We run Vali on Kubernetes with the help of ksonnet.
You can take a look at [our production setup](ksonnet/).

To learn more about ksonnet, check out its [documentation](https://ksonnet.io).
