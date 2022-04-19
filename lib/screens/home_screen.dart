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
                    size: 100,
                  )
                : Icon(
                    Icons.tv_off_outlined,
                    color: Colors.red,
                    size: 100,
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
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                prod.productosEnviar[index].name,
                                style: TextStyle(fontSize: 20),
                              ),
                              width: double.infinity,
                              height: 20,
                              color: Colors.white,
                            ),
                            ClipRRect(
                              child: Container(
                                height: 200,
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
                String listaIdProds = "";
                if (socket.serverStatus == ServerStatus.Online) {
                  prod.productosEnviar.forEach((e) {
                    print('${e.toMap()}');
                    listaIdProds = listaIdProds + e.rfidTag;
                  });
                  socket.socket.emit('client-app', listaIdProds);
                  prod.clearProds();
                } else {
                  return;
                }
              },
              color: Colors.indigo,
              child: Text(
                'Comprar',
                style: TextStyle(color: Colors.white, fontSize: 15),
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
