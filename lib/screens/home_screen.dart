import 'package:client_lpro_app/screens/loading_page.dart';
import 'package:client_lpro_app/services/product_service.dart';
import 'package:client_lpro_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  int a = 0;
  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context);
    final prod = Provider.of<ProductService>(context);

    if (socket.serverStatus == ServerStatus.Connecting)
      return LoadingScreen(texto: 'Conectando con el servidor');

    socket.socket.on('fin-de-pedido', (data) {
      print('$a ${data}');
      a++;
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Info.'),
      //       content: Text(data),
      //     );
      //   },
      // );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Client App',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'ip');
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            socket.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.shopify_outlined,
                    color: Colors.green,
                    size: 70,
                  )
                : Icon(
                    Icons.tv_off_outlined,
                    color: Colors.red,
                    size: 70,
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
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          prod.productosEnviar.clear();
                        },
                        child: Container(
                          height: 200,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: Container(
                                  height: 100,
                                  width: 150,
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
              elevation: 70,
              onPressed: socket.serverStatus != ServerStatus.Online
                  ? null
                  : () {
                      // print(prod.products);
                      String listaIdProds = "";
                      if (socket.serverStatus == ServerStatus.Online) {
                        prod.productosEnviar.forEach((e) {
                          print('${e.toMap()}');
                          prod.updateProducto(e);
                          // listaIdProds = listaIdProds + e.rfidTag;

                          socket.socket.emit('client-app', e.toMap());
                        });
                        socket.socket.emit('client-app', "fin-pedido");
                        prod.clearProds();
                      } else {
                        return;
                      }
                    },
              color: Colors.indigo,
              child: Text(
                'Comprar',
                style: TextStyle(
                    fontSize: 15,
                    color: socket.serverStatus != ServerStatus.Online
                        ? Colors.black26
                        : Colors.white),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          height: 300,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              Container(
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Text(
                                      prod.products[index].name,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Positioned(
                                      child: prod.products[index].stock != 0
                                          ? Text(
                                              'Quedan: ${prod.products[index].stock}')
                                          : Text(
                                              "No hay stock",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                      top: 0,
                                      right: 0,
                                    )
                                  ],
                                ),
                                width: double.infinity,
                                height: 30,
                                color: Colors.white,
                              ),
                              ClipRRect(
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage('assets/load.gif'),
                                    image: NetworkImage(
                                        prod.products[index].picture),
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                        const Duration(milliseconds: 100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (prod.products[index].stock == 0) return;
                          prod.products[index].stock =
                              prod.products[index].stock - 1;
                          print(prod.products[index].stock);
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
