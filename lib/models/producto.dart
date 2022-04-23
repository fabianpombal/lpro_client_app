// To parse this JSON data, do
//
//     final producto = productoFromMap(jsonString);

import 'dart:convert';

class Producto {
  Producto({
    required this.columna,
    required this.name,
    required this.picture,
    required this.rfidTag,
    required this.stock,
    required this.fila,
  });

  int columna;
  String name;
  String picture;
  String rfidTag;
  int stock;
  int fila;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
      columna: json["columna"],
      name: json["name"],
      picture: json["picture"],
      rfidTag: json["rfidTag"],
      stock: json["stock"],
      fila: json["fila"]);

  Map<String, dynamic> toMap() => {
        "columna": columna,
        "name": name,
        "picture": picture,
        "rfidTag": rfidTag,
        "stock": stock,
        "fila": fila,
      };
}
