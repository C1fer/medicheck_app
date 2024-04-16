import 'dart:convert';
import 'tipo_producto.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

class Producto {
  int idProducto;
  String nombre;
  String fechaRegistro;
  String? CUPS;
  bool isPDSS;
  TipoProducto? idTipoProductoNavigation;

  Producto(
      {required this.idProducto,
      required this.nombre,
      required this.fechaRegistro,
      required this.CUPS,
      required this.isPDSS,
      required this.idTipoProductoNavigation});

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
      idProducto: json["idProducto"],
      nombre: json["nombre"],
      fechaRegistro: json["fechaRegistro"],
      CUPS: json["cups"],
      isPDSS: json["isPdss"],
      idTipoProductoNavigation: json["idTipoNavigation"] != null
          ? TipoProducto.fromJson(json["idTipoNavigation"])
          : null
      );
}
