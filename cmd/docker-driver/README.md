# Vali Docker Logging Driver

## Overview

Docker logging driver plugins extends Docker's logging capabilities. You can use Vali Docker logging driver plugin to send
Docker container logs directly to your Vali instance.

> Docker plugins are not yet supported on Windows; see Docker's logging driver plugin [documentation](https://docs.docker.com/engine/extend/)

The documentation source code of the plugin is available in the [documentation folder](../../docs/sources/clients/docker-driver/).

## Contributing

This directory contains the code source of the docker driver.
To build and contribute. you will need:

- Docker
- Makefile
- Optionally go 1.14 installed.

To build the driver you can use `make docker-driver`, then you can install this driver using `make docker-driver-enable`.
If you want to uninstall the driver simply run `make docker-driver-clean`.

Make you update the [documentation](../../docs/sources/clients/docker-driver/) accordingly when submitting a new change.
