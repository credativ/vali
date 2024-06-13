FROM golang:1.22.4 as build
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && make BUILD_IN_CONTAINER=false fluent-bit-plugin

FROM fluent/fluent-bit:1.4
COPY --from=build /src/vali/cmd/fluent-bit/out_plutono_vali.so /fluent-bit/bin
COPY cmd/fluent-bit/fluent-bit.conf /fluent-bit/etc/fluent-bit.conf
EXPOSE 2020
CMD ["/fluent-bit/bin/fluent-bit", "-e","/fluent-bit/bin/out_plutono_vali.so", "-c", "/fluent-bit/etc/fluent-bit.conf"]
