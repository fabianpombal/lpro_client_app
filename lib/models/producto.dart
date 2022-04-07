// To parse this JSON data, do
//
//     final producto = productoFromMap(jsonString);

import 'dart:convert';

class Producto {
  Producto({
    required this.estante,
    required this.name,
    required this.picture,
    required this.rfidTag,
    required this.stock,
    required this.valda,
  });

  int estante;
  String name;
  String picture;
  String rfidTag;
  int stock;
  int valda;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
      estante: json["estante"],
      name: json["name"],
      picture: json["picture"],
      rfidTag: json["rfidTag"],
      stock: json["stock"],
      valda: json["valda"]);

  Map<String, dynamic> toMap() => {
        "estante": estante,
        "name": name,
        "picture": picture,
        "rfidTag": rfidTag,
        "stock": stock,
        "valda": valda,
      };
}
