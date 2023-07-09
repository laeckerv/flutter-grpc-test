#!/bin/bash

protoc --dart_out=grpc:app/lib/src/generated server/de.privat.grpc.test/src/main/proto/helloworld.proto
