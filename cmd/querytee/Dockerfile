FROM golang:1.24.5 as build

ARG TOUCH_PROTOS
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && make BUILD_IN_CONTAINER=false vali-querytee

FROM alpine:3.22.1
RUN apk add --update --no-cache ca-certificates
COPY --from=build /src/vali/cmd/querytee/vali-querytee /usr/bin/querytee
ENTRYPOINT [ "/usr/bin/querytee" ]
