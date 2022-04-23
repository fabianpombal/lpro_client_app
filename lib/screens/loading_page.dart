import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final String texto;
  const LoadingScreen({Key? key, required this.texto}) : super(key: key);

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
              texto,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, 'ip');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("cambiar la ip del servidor",
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                  SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  )
                ],
              ),
            )
          ],
        )));
  }
}
