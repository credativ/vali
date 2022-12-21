<a href="https://goreportcard.com/report/github.com/credativ/vali"><img src="https://goreportcard.com/badge/github.com/credativ/vali" alt="Go Report Card" /></a>

# Vali: like Prometheus, but for logs

Vali is a fork of [Loki](https://github.com/grafana/loki/) 2.2.1 under the Apache 2.0 License.
It is currently limited to maintenance and security updates.

Vali is a horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by [Prometheus](https://prometheus.io/).
It is designed to be very cost effective and easy to operate.
It does not index the contents of the logs, but rather a set of labels for each log stream.

Compared to other log aggregation systems, Vali:

- does not do full text indexing on logs. By storing compressed, unstructured logs and only indexing metadata, Vali is simpler to operate and cheaper to run.
- indexes and groups log streams using the same labels you’re already using with Prometheus, enabling you to seamlessly switch between metrics and logs using the same labels that you’re already using with Prometheus.
- is an especially good fit for storing [Kubernetes](https://kubernetes.io/) Pod logs. Metadata such as Pod labels is automatically scraped and indexed.
- has native support in Plutono (needs Plutono v6.0).

A Vali-based logging stack consists of 3 components:

- `valitail` is the agent, responsible for gathering logs and sending them to Vali.
- `vali` is the main server, responsible for storing logs and processing queries.
- [Plutono](https://github.com/credativ/plutono) for querying and displaying the logs.

Vali is like Prometheus, but for logs: we prefer a multidimensional label-based approach to indexing, and want a single-binary, easy to operate system with no dependencies.
Vali differs from Prometheus by focusing on logs instead of metrics, and delivering logs via push, instead of pull.


## About this fork

Assuming that you want to switch from using Loki to Vali, you may need to change the name of images, executables, configurations files, their paths, and in some cases configuration items.

- The container image path changes from `[docker.io/]grafana/loki` to `ghcr.io/credativ/vali:<version>`. Use version `main` for the latest development snapshot.
- Occurences of `loki` in any letter case are replaced by `vali` in the same case.
- Occurences of `grafana` in any letter case are replaced by `plutono` in the same case.
- Occurences of `promtail` in any letter case are replaced by `valitail` in the same case. (This includes the executable and image names.)

Vali is not compatible with Grafana due to internal renaming. See [Plutono](https://github.com/credativ/plutono) for the accompanying fork of Grafana.


### Building from source

Vali can be run in a single host, no-dependencies mode using the following commands.

You need `go`, we recommend using the version found in [our build Dockerfile](https://github.com/credativ/vali/blob/master/vali-build-image/Dockerfile)

```bash

$ go get github.com/credativ/vali
$ cd $GOPATH/src/github.com/credativ/vali # GOPATH is $HOME/go by default.

$ go build ./cmd/vali
$ ./vali -config.file=./cmd/vali/vali-local-config.yaml
...
```

To build Valitail on non-Linux platforms, use the following command:

```bash
$ go build ./cmd/valitail
```

On Linux, Valitail requires the systemd headers to be installed for
Journal support.

With Journal support on Ubuntu, run with the following commands:

```bash
$ sudo apt install -y libsystemd-dev
$ go build ./cmd/valitail
```

With Journal support on CentOS, run with the following commands:

```bash
$ sudo yum install -y systemd-devel
$ go build ./cmd/valitail
```

Otherwise, to build Valitail without Journal support, run `go build`
with CGO disabled:

```bash
$ CGO_ENABLED=0 go build ./cmd/valitail
```

## License

Apache License 2.0, see [LICENSE](LICENSE).
