import 'dart:isolate';

import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Isolate App"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Image.asset('assets/gifs/bouncing-ball.gif'),
            ElevatedButton(
                onPressed: () async {
                  final total = await complexTask1();
                  debugPrint('Res1: $total');
                },
                child: const Text('Task 1')),
            //Isolate
            ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  await Isolate.spawn(
                      (port) => complexTask2(port), receivePort.sendPort);
                  receivePort.listen((total) => debugPrint('Res2: $total'));
                },
                child: const Text('Task 2')),
            //Isolate with parameters
            ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  await Isolate.spawn((port) => complexTask3(port),
                      Data(1000000000, receivePort.sendPort));
                  receivePort.listen((total) => debugPrint('Res3: $total'));
                },
                child: const Text('Task 3'))
          ],
        ),
      )),
    );
  }

  Future<double> complexTask1() async {
    var total = 0.0;

    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

complexTask2(SendPort sendPort) {
  var total = 0.0;

  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}

complexTask3(Data data) {
  var total = 0.0;

  for (var i = 0; i < data.iteration; i++) {
    total += i;
  }
  data.sendPort.send(total);
}

// -- POJO --

class Data {
  final int iteration;
  final SendPort sendPort;

  Data(this.iteration, this.sendPort);
}
