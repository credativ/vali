FROM golang:1.22.5 as build

ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && (if [ "${TOUCH_PROTOS}" ]; then make touch-protos; fi) && make BUILD_IN_CONTAINER=false logcli

FROM alpine:3.20.1

RUN apk add --no-cache ca-certificates

COPY --from=build /src/vali/cmd/logcli/logcli /usr/bin/logcli

ENTRYPOINT [ "/usr/bin/logcli" ]
