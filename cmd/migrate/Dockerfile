FROM golang:1.22.4 as build
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && make BUILD_IN_CONTAINER=false migrate

FROM alpine:3.20.0
RUN apk add --update --no-cache ca-certificates
COPY --from=build /src/vali/cmd/migrate/migrate /usr/bin/migrate
#ENTRYPOINT [ "/usr/bin/migrate" ]
CMD tail -f /dev/null
