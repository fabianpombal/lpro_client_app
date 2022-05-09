import 'package:client_lpro_app/mqtt/MQTTManager.dart';
import 'package:client_lpro_app/mqtt/state/MQTTAppState.dart';
import 'package:client_lpro_app/services/product_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int a = 0;
  late MQTTManager manager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductService>(context);
    final appState = Provider.of<MQTTAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client App',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                if (appState.getAppConnectionState ==
                    MQTTAppConnectionState.disconnected) {
                  manager = MQTTManager(
                      host: '192.168.56.208',
                      topic: 'nuevo_pedido',
                      id: 'controller5',
                      state: appState);
                  manager.initializeMQTTClient();
                  manager.connect();
                } else if (appState.getAppConnectionState ==
                    MQTTAppConnectionState.connected) {
                  manager.disconnect();
                }
              },
              icon: Icon(
                Icons.connect_without_contact,
                color: appState.getAppConnectionState ==
                        MQTTAppConnectionState.disconnected
                    ? Colors.red
                    : Colors.green,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            appState.getAppConnectionState == MQTTAppConnectionState.connected
                ? const Icon(
                    Icons.shopping_cart,
                    color: Colors.green,
                    size: 70,
                  )
                : const Icon(
                    Icons.remove_shopping_cart,
                    color: Colors.red,
                    size: 70,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey,
                child: _GridViewCustom(prod: prod),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            MaterialButton(
              elevation: 70,
              onPressed: appState.getAppConnectionState ==
                      MQTTAppConnectionState.disconnected
                  ? null
                  : () {
                      // print(prod.products);
                      String listaIdProds = "";
                      if (appState.getAppConnectionState ==
                          MQTTAppConnectionState.connected) {
                        for (var e in prod.productosEnviar) {
                          print('${e.toMap()}');
                          prod.updateProducto(e);
                          // listaIdProds = listaIdProds + e.rfidTag;
                          manager.publish(e.toJson(), 'nuevo_pedido');
                        }
                        manager.publish('fin-pedido', 'nuevo_pedido');

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
                    color: appState.getAppConnectionState ==
                            MQTTAppConnectionState.disconnected
                        ? Colors.black26
                        : Colors.white),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
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
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              _ContainerOfAvailableProducts(
                                prod: prod,
                                index: index,
                              ),
                              _ImageOfAvailableProducts(
                                prod: prod,
                                index: index,
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

class _ImageOfAvailableProducts extends StatelessWidget {
  const _ImageOfAvailableProducts({
    Key? key,
    required this.prod,
    required this.index,
  }) : super(key: key);

  final ProductService prod;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: FadeInImage(
          placeholder: const AssetImage('assets/load.gif'),
          image: NetworkImage(prod.products[index].picture),
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 100),
        ),
      ),
    );
  }
}

class _ContainerOfAvailableProducts extends StatelessWidget {
  const _ContainerOfAvailableProducts({
    Key? key,
    required this.prod,
    required this.index,
  }) : super(key: key);

  final ProductService prod;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Text(
            prod.products[index].name,
            style: const TextStyle(fontSize: 17),
          ),
          Positioned(
            child: prod.products[index].stock != 0
                ? Text('Quedan: ${prod.products[index].stock}')
                : const Text(
                    "No hay stock",
                    style: TextStyle(color: Colors.red),
                  ),
            top: 0,
            right: 0,
          )
        ],
      ),
      width: double.infinity,
      height: 30,
      color: Colors.white,
    );
  }
}

class _GridViewCustom extends StatelessWidget {
  const _GridViewCustom({
    Key? key,
    required this.prod,
  }) : super(key: key);

  final ProductService prod;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SizedBox(
                      height: 100,
                      width: 150,
                      child: Image(
                        image:
                            NetworkImage(prod.productosEnviar[index].picture),
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
    );
  }
}
