import 'package:client_lpro_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectIpScreen extends StatelessWidget {
  const SelectIpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context);
    String ipAux = "";
    return Scaffold(
      body: Center(
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "192.168.1.41", labelText: "Cambia la Ip"),
                onChanged: (value) {
                  ipAux = value;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  socket.ip = ipAux;
                  Navigator.pop(context);
                },
                child: Text(
                  "Confirmar",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              )
            ],
          ),
        )),
      ),
    );
  }
}
