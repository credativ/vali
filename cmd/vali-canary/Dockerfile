FROM golang:1.23.5 as build
# TOUCH_PROTOS signifies if we should touch the compiled proto files and thus not regenerate them.
# This is helpful when file system timestamps can't be trusted with make
ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && (if [ "${TOUCH_PROTOS}" ]; then make touch-protos; fi) && make BUILD_IN_CONTAINER=false vali-canary

FROM alpine:3.21.2
RUN apk add --update --no-cache ca-certificates
COPY --from=build /src/vali/cmd/vali-canary/vali-canary /usr/bin/vali-canary
ENTRYPOINT [ "/usr/bin/vali-canary" ]
