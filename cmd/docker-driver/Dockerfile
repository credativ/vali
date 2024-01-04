ARG BUILD_IMAGE=ghcr.io/credativ/vali-build-image:0.12.0
# Directories in this file are referenced from the root of the project not this folder
# This file is intended to be called from the root like so:
# docker build -t ghcr.io/credativ/vali -f cmd/vali/Dockerfile .

# TODO: add cross-platform support
FROM $BUILD_IMAGE as build
COPY . /src/vali
WORKDIR /src/vali
RUN make clean && make BUILD_IN_CONTAINER=false cmd/docker-driver/docker-driver

FROM alpine:3.19
RUN apk add --update --no-cache ca-certificates tzdata
COPY --from=build /src/vali/cmd/docker-driver/docker-driver /bin/docker-driver
WORKDIR /bin/
ENTRYPOINT [ "/bin/docker-driver" ]
