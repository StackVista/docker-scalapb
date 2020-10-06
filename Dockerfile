FROM adoptopenjdk/openjdk11:jdk-11.28-alpine

ENV SCALAPB_VERSION=0.10.8

RUN apk add --no-cache curl bash

RUN mkdir /scalapb && \
    curl -L https://github.com/scalapb/ScalaPB/releases/download/v${SCALAPB_VERSION}/scalapbc-${SCALAPB_VERSION}.zip | unzip -d /scalapb - && \
    mv /scalapb/scalapbc-${SCALAPB_VERSION}/* /scalapb &&\
    rm -rf /scalapb/scalapbc-${SCALAPB_VERSION} &&\
    chmod ugo+x /scalapb/bin/scalapbc

RUN mkdir -p /protobuf/google/protobuf && \
    for f in any duration descriptor empty struct timestamp wrappers; do \
    curl -L -o /protobuf/google/protobuf/${f}.proto https://raw.githubusercontent.com/google/protobuf/master/src/google/protobuf/${f}.proto; \
    done && \
    mkdir -p /protobuf/google/api && \
    for f in annotations http; do \
    curl -L -o /protobuf/google/api/${f}.proto https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/third_party/googleapis/google/api/${f}.proto; \
    done

COPY rootfs /

ENTRYPOINT [ "/scalapb.sh" ]
