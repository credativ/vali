FROM ruby:2.6 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo make gcc g++ libc-dev ruby-dev golang

COPY . /src/vali
WORKDIR /src/vali
RUN make BUILD_IN_CONTAINER=false fluentd-plugin

FROM fluent/fluentd:v1.9.2-debian-1.0
ENV VALI_URL "https://logs-prod.example.com"

COPY --from=build /src/vali/cmd/fluentd/lib/fluent/plugin/out_vali.rb /fluentd/plugins/out_vali.rb

COPY cmd/fluentd/docker/Gemfile /fluentd/
COPY cmd/fluentd/docker/conf/vali.conf /fluentd/etc/vali.conf

USER root
RUN sed -i '$i''  @include vali.conf' /fluentd/etc/fluent.conf
USER fluent
