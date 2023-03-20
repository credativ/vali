FROM golang:1.20.2-buster as build
# TOUCH_PROTOS signifies if we should touch the compiled proto files and thus not regenerate them.
# This is helpful when file system timestamps can't be trusted with make
ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -t buster-backports -qy libsystemd-dev
RUN make clean && (if [ "${TOUCH_PROTOS}" ]; then make touch-protos; fi) && make BUILD_IN_CONTAINER=false valitail

# Valitail requires debian as the base image to support systemd journal reading
FROM debian:buster-slim
# tzdata required for the timestamp stage to work
# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
RUN apt-get update && \
  apt-get install -qy \
  tzdata ca-certificates
RUN apt-get install -t buster-backports -qy libsystemd-dev && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build /src/vali/cmd/valitail/valitail /usr/bin/valitail
COPY cmd/valitail/valitail-docker-config.yaml /etc/valitail/config.yml
ENTRYPOINT ["/usr/bin/valitail"]
CMD ["-config.file=/etc/valitail/config.yml"]
