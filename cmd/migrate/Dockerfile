FROM golang:1.23.2 as build
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && make BUILD_IN_CONTAINER=false migrate

FROM alpine:3.20.3
RUN apk add --update --no-cache ca-certificates
COPY --from=build /src/vali/cmd/migrate/migrate /usr/bin/migrate
#ENTRYPOINT [ "/usr/bin/migrate" ]
CMD tail -f /dev/null
