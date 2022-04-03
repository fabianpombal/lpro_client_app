import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWanderingCubes(
              color: Colors.white,
              size: 100.50,
            ),
            Text(
              'Conectando con el servidor...',
              style: TextStyle(fontSize: 17, color: Colors.white),
            )
          ],
        )));
  }
}
