import 'dart:convert';

TipoProducto tipoProductoFromJson(String str) =>
    TipoProducto.fromJson(json.decode(str));

class TipoProducto {
  int id;
  String nombre;

  TipoProducto({required this.id, required this.nombre});

  factory TipoProducto.fromJson(Map<String, dynamic> json) =>
      TipoProducto(id: json["id"], nombre: json["descripcion"]);
}
