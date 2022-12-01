FROM golang:1.15.3 as build
# TOUCH_PROTOS signifies if we should touch the compiled proto files and thus not regenerate them.
# This is helpful when file system timestamps can't be trusted with make
ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && (if [ "${TOUCH_PROTOS}" ]; then make touch-protos; fi) && make BUILD_IN_CONTAINER=false vali

FROM alpine:3.9

RUN apk add --no-cache ca-certificates libcap

COPY --from=build /src/vali/cmd/vali/vali /usr/bin/vali
COPY cmd/vali/vali-docker-config.yaml /etc/vali/local-config.yaml

RUN addgroup -g 10001 -S vali && \
    adduser -u 10001 -S vali -G vali
RUN mkdir -p /vali/rules && \
    mkdir -p /vali/tmprules && \
    chown -R vali:vali /etc/vali /vali

# See https://github.com/grafana/loki/issues/1928
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

USER vali
EXPOSE 3100
ENTRYPOINT [ "/usr/bin/vali" ]
CMD ["-config.file=/etc/vali/local-config.yaml"]
