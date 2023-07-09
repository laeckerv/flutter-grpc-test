import 'dart:async';
import 'dart:math';

import 'package:app/src/generated/server/de.privat.grpc.test/src/main/proto/helloworld.pb.dart';
import 'package:app/src/service/greeter_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  GreeterService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = "";

  StreamSubscription<HelloReply>? _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_message),
            ElevatedButton(
                onPressed: _sendNewName, child: const Text('Send new name'))
          ],
        ),
      ),
      floatingActionButton: _subscription == null
          ? FloatingActionButton(
              onPressed: _subscribeToHelloStream,
              tooltip: 'Subscribe',
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _unsubscribeFromHelloStream,
              tooltip: 'Remove',
              child: const Icon(Icons.remove),
            ),
    );
  }

  showError(Object? error) {
    Fluttertoast.showToast(
      msg: "Error on subscription: $error",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: 'red',
      webPosition: 'center',
    );
  }

  void _sendNewName() {
    GreeterService.instance.greeterClient
        .sayHello(HelloRequest()..name = 'Name ${Random().nextInt(1000)}')
        .onError(
          (error, stackTrace) => showError(error),
        );
  }

  void _subscribeToHelloStream() {
    final subscription = _subscription ??
        GreeterService.instance.greeterClient
            .sayHelloStream(EmptyRequest())
            .listen((response) {
          setState(() {
            _message = response.message;
          });
        }, onError: (e) {
          showError(e);
          setState(() {
            _subscription = null;
          });
        }, onDone: () {
          setState(() {
            _subscription = null;
          });
        });
    setState(() {
      _subscription = subscription;
    });
  }

  void _unsubscribeFromHelloStream() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    setState(() {
      _subscription = null;
    });
  }
}
