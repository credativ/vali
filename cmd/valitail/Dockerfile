FROM golang:1.23.4-bookworm as build
# TOUCH_PROTOS signifies if we should touch the compiled proto files and thus not regenerate them.
# This is helpful when file system timestamps can't be trusted with make
ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
RUN apt-get update && apt-get install -qy libsystemd-dev
RUN make clean && (if [ "${TOUCH_PROTOS}" ]; then make touch-protos; fi) && make BUILD_IN_CONTAINER=false valitail

# Valitail requires debian as the base image to support systemd journal reading
FROM debian:bookworm-slim
# tzdata required for the timestamp stage to work
RUN apt-get update && \
  apt-get install -qy \
  tzdata ca-certificates libsystemd-dev && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build /src/vali/cmd/valitail/valitail /usr/bin/valitail
COPY cmd/valitail/valitail-docker-config.yaml /etc/valitail/config.yml
ENTRYPOINT ["/usr/bin/valitail"]
CMD ["-config.file=/etc/valitail/config.yml"]
