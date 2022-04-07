import 'dart:convert';

import 'package:client_lpro_app/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  List<Producto> products = [];
  List<Producto> productosEnviar = [];
  final String _baseUrl =
      "lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app";
  bool isLoading = true;

  ProductService() {
    this.loadProductos();
  }

  Future<List<Producto>> loadProductos() async {
    notifyListeners();
    final url = Uri.https(this._baseUrl, 'productos.json');
    final res = await http.get(url);
    final Map<String, dynamic> productosMap = json.decode(res.body);
    productosMap.forEach((key, value) {
      final tempProduct = Producto.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return this.products;
  }

  void addProductos(Producto a) {
    productosEnviar.add(a);
    notifyListeners();
  }

  void clearProds() {
    productosEnviar.forEach(
      (element) => print(element.toMap()),
    );
    productosEnviar.clear();

    notifyListeners();
  }
}
