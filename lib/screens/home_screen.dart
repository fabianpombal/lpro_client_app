import 'package:client_lpro_app/screens/loading_page.dart';
import 'package:client_lpro_app/services/product_service.dart';
import 'package:client_lpro_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context);
    final prod = Provider.of<ProductService>(context);

    // if (socket.serverStatus == ServerStatus.Connecting) {
    //   return LoadingScreen();
    // }

    List<String> productos = [
      'Producto1',
      'Producto2',
      'Producto3',
      'Producto4',
      'Producto5',
      'Producto6',
      'Producto7',
      'Producto8'
    ];

    socket.socket.on('nuevo-mensaje', (value) {
      prod.name = value.toString();
      prod.cambioEstado();
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Client App',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.all(8),
              child: socket.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.wifi,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.wifi_off,
                      color: Colors.red,
                    ),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.shopify_outlined,
              color: Colors.green,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 100,
                        color: Colors.deepPurpleAccent,
                        child: Text(prod.products[index]),
                      ),
                    );
                  },
                  itemCount: prod.products.length,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            MaterialButton(
              onPressed: () {
                // print(prod.products);
                if (socket.serverStatus == ServerStatus.Online) {
                  prod.products.forEach((element) {
                    socket.socket.emit('client-app', {"name": element});
                  });
                  prod.clearProducts();
                } else {
                  return;
                }
              },
              color: Colors.indigo,
              child: Text(
                'Comprar',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          height: 50,
                          width: 100,
                          child: Text(productos[index]),
                          color: Colors.green,
                        ),
                        onTap: () {
                          prod.addProduct(productos[index]);
                        },
                      ),
                    );
                  },
                  itemCount: productos.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
