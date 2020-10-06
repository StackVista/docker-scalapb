#!/usr/bin/env bash

set -uxoe pipefail

ZIO_VERSION="0.4.0"

SCALAPBC_PLUGINS=""
SCALAPBC_OUTS=""
PROTOFILES=""
PROTODIR=""

# Parse arguments
while getopts "z:i:o:b:" opt; do
  case "${opt}" in
  z)
    SCALAPBC_PLUGINS="--plugin-artifact=com.thesamet.scalapb.zio-grpc:protoc-gen-zio:${ZIO_VERSION}:default,classifier=unix,ext=sh,type=jar"
    SCALAPBC_OUTS="${SCALAPBC_OUTS} --zio_out=${OPTARG}"
     ;;
  i) PROTOFILES="${PROTOFILES} ${OPTARG}" ;;
  o) SCALAPBC_OUTS="${SCALAPBC_OUTS} --scala_out=grpc:${OPTARG}" ;;
  b) PROTODIR="${OPTARG}" ;;
 \?) echo "Unknown option: -${OPTARG}" >&2; exit 1;;
  :) echo "Missing option argument for -${OPTARG}" >&2; exit 1;;
  *) echo "Unimplemented option: -${OPTARG}" >&2; exit 1;;
  esac
done

cd ${PROTODIR}

/scalapb/bin/scalapbc ${SCALAPBC_PLUGINS} -- ${PROTOFILES} ${SCALAPBC_OUTS} -I/protobuf -I.
