import 'package:flutter/material.dart';

class ProductService extends ChangeNotifier {
  List<String> products = [];
  String name = '812763';

  ProductService() {}

  void addProduct(String name) {
    products.add(name);
    notifyListeners();
  }

  void clearProducts() {
    products.clear();
    notifyListeners();
  }

  void cambioEstado() {
    notifyListeners();
  }
}
