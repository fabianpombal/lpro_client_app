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

    if (socket.serverStatus == ServerStatus.Connecting) {
      return LoadingScreen(
        texto: 'Conectando con el servidor...',
      );
    }

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
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              child: Text(prod.productosEnviar[index].name),
                              width: double.infinity,
                              height: 20,
                              color: Colors.white,
                            ),
                            ClipRRect(
                              child: Container(
                                height: 100,
                                width: 200,
                                child: Image(
                                  image: NetworkImage(
                                      prod.productosEnviar[index].picture),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: prod.productosEnviar.length,
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
                  prod.productosEnviar.forEach((element) {
                    print('emitido: ${element.toMap()}');
                    socket.socket.emit('add-product', element.toMap());
                  });

                  prod.clearProds();
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
                          height: 100,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                child: Text(prod.products[index].name),
                                width: double.infinity,
                                height: 20,
                                color: Colors.white,
                              ),
                              ClipRRect(
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Image(
                                    image: NetworkImage(
                                        prod.products[index].picture),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          prod.addProductos(prod.products[index]);
                        },
                      ),
                    );
                  },
                  itemCount: prod.products.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
