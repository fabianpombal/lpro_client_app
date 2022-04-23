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
    this.products.sort((a, b) => a.stock.compareTo(b.stock));
    notifyListeners();
    return this.products;
  }

  Future<String> updateProducto(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos/${producto.id}.json');
    final res = await http.put(url, body: producto.toJson());
    final decodedData = res.body;
    final index =
        this.products.indexWhere((element) => element.id == producto.id);
    this.products[index] = producto;
    return producto.id!;
  }

  Future<String> createProducto(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos.json');
    final res = await http.put(url, body: producto.toJson());
    final decodedData = json.decode(res.body);
    producto.id = decodedData["name"];
    this.products.add(producto);
    return '';
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
