import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  int idProducto;
  String nombre;
  String descripcion;
  bool? habilitado;
  String tipo;
  String categoria;
  String fechaRegistro;
  List<dynamic> cobeturas;
  List<dynamic> productosGuardados;
  List<dynamic> reporteIncidentes;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.descripcion,
    required this.habilitado,
    required this.tipo,
    required this.categoria,
    required this.fechaRegistro,
    required this.cobeturas,
    required this.productosGuardados,
    required this.reporteIncidentes,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    idProducto: json["IdProducto"],
    nombre: json["Nombre"],
    descripcion: json["Descripcion"],
    habilitado: json["Habilitado"],
    tipo: json["Tipo"],
    categoria: json["Categoria"],
    fechaRegistro: json["FechaRegistro"],
    cobeturas: json["Coberturas"] != null ? List<dynamic>.from(json["Coberturas"].map((x) => x)) : [],
    productosGuardados: json["ProductosGuardados"] != null ? List<dynamic>.from(json["ProductosGuardados"].map((x) => x)) : [],
    reporteIncidentes: json["ReporteIncidentes"] != null ? List<dynamic>.from(json["ReporteIncidentes"].map((x) => x)) : [],
  );

  Map<String, dynamic> toJson() => {
    "IdProducto": idProducto,
    "Nombre": nombre,
    "Descripcion": descripcion,
    "Habilitado": habilitado,
    "Tipo": tipo,
    "Categoria": categoria,
    "FechaRegistro": fechaRegistro,
    "Cobeturas": List<dynamic>.from(cobeturas.map((x) => x)),
    "ProductosGuardados": List<dynamic>.from(productosGuardados.map((x) => x)),
    "ReporteIncidentes": List<dynamic>.from(reporteIncidentes.map((x) => x)),
  };
}