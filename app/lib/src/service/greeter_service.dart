import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import '../generated/server/de.privat.grpc.test/src/main/proto/helloworld.pbgrpc.dart';

class GreeterService {
  String baseUrl = !kIsWeb && Platform.isAndroid ? "10.0.2.2" : "localhost";
  int port = 9090;

  GreeterService._internal();
  static final GreeterService _instance = GreeterService._internal();

  factory GreeterService() => _instance;

  static GreeterService get instance => _instance;

  late GreeterClient _greeterClient;

  Future<void> init() async {
    final channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
        host: baseUrl, port: port, transportSecure: false);
    _greeterClient = GreeterClient(channel);
  }

  GreeterClient get greeterClient {
    return _greeterClient;
  }
}
