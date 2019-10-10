FROM openjdk:8

USER root:root

ARG LOGSTASH_VERSION=7.3.1
ARG PATH_LOGSTASH_HOME=/usr/share/logstash
WORKDIR $PATH_LOGSTASH_HOME

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -yq install git rake && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/elastic/logstash.git $PATH_LOGSTASH_HOME
RUN git checkout v$LOGSTASH_VERSION
RUN ./gradlew bootstrap
RUN ./bin/logstash-plugin install --development
RUN rake test:install-default

COPY docker/bundle /usr/share/logstash/bin/bundle
COPY docker/gem /usr/share/logstash/bin/gem

CMD bin/logstash