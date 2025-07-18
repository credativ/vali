FROM alpine as helm
ARG HELM_VER="v3.2.3"

RUN apk add --no-cache curl && \
    curl -L -o /tmp/helm-$HELM_VER.tgz https://get.helm.sh/helm-${HELM_VER}-linux-amd64.tar.gz && \
    tar -xz -C /tmp -f /tmp/helm-$HELM_VER.tgz && \
    mv /tmp/linux-amd64/helm /usr/bin/helm && \
    rm -rf /tmp/linux-amd64 /tmp/helm-$HELM_VER.tgz

FROM alpine as golangci
RUN apk add --no-cache curl && \
    cd / && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.52.0

FROM alpine:edge as docker
RUN apk add --no-cache docker-cli

# Install faillint used to lint go imports in CI.
# This collisions with the version of go tools used in the base image, thus we install it in its own image and copy it over.
# Error:
#	github.com/fatih/faillint@v1.5.0 requires golang.org/x/tools@v0.0.0-20200207224406-61798d64f025
#   (not golang.org/x/tools@v0.0.0-20190918214920-58d531046acd from golang.org/x/tools/cmd/goyacc@58d531046acdc757f177387bc1725bfa79895d69)
FROM docker.io/library/golang:1.24.5 as faillint
RUN go install github.com/fatih/faillint@v1.14.0

FROM docker.io/library/golang:1.24.5-bookworm
RUN apt-get update && \
    apt-get install -qy \
    musl gnupg \
    file zip unzip jq gettext\
    protobuf-compiler libprotobuf-dev \
    libsystemd-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=docker /usr/bin/docker /usr/bin/docker
COPY --from=helm /usr/bin/helm /usr/bin/helm
COPY --from=golangci /bin/golangci-lint /usr/local/bin
COPY --from=faillint /go/bin/faillint /usr/bin/faillint

# Install some necessary dependencies.
RUN go install github.com/golang/protobuf/protoc-gen-go@v1.3.0 && \
    go install github.com/gogo/protobuf/protoc-gen-gogoslick@v1.2.1 && \
    go install github.com/go-delve/delve/cmd/dlv@v1.24.2 && \
    # Due to the lack of a proper release tag, we use the commit hash of
    # https://github.com/golang/tools/releases v0.1.7
    go install golang.org/x/tools/cmd/goyacc@58d531046acdc757f177387bc1725bfa79895d69 && \
    go install github.com/mitchellh/gox@v1.0.1 && \
    go install github.com/tcnksm/ghr@v0.13 && \
    rm -rf /go/pkg /go/src
ENV GOCACHE=/go/cache

COPY build.sh /
RUN chmod +x /build.sh
ENTRYPOINT ["/build.sh"]
