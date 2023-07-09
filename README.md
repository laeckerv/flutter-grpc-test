# Flutter Mobile/Web grpc POC

This repository is a simple poc for unsing grpc with flutter (including flutter web!)

## Getting started

### Server

This starts the quarkus server together with the envoy proxy (needed for grpc web compatibility http/1);

The quarkus server will be exposed at `8080`, the proxy at `9090`

```bash
cd server/de.private.grpc.test
mvn package
cd ../../
docker-compose up
```

### App

Start the app however you like, e.g.

```bash
cd app
flutter run -d chrome
```

## Restrictions

- At the moment grpc web does not support client-side streaming or bidirectional streaming
