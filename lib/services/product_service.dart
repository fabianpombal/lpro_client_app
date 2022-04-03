import 'package:flutter/material.dart';

class ProductService extends ChangeNotifier {
  List<String> products = [];

  ProductService() {}

  void addProduct(String name) {
    products.add(name);
    notifyListeners();
  }

  void clearProducts() {
    products.clear();
    notifyListeners();
  }
}
