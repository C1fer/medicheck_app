import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  int idProducto;
  String nombre;
  String descripcion;
  bool habilitado;
  String tipo;
  String categoria;
  DateTime fechaRegistro;
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
    idProducto: json["idProducto"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    habilitado: json["habilitado"],
    tipo: json["tipo"],
    categoria: json["categoria"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    cobeturas: List<dynamic>.from(json["cobeturas"].map((x) => x)),
    productosGuardados: List<dynamic>.from(json["productosGuardados"].map((x) => x)),
    reporteIncidentes: List<dynamic>.from(json["reporteIncidentes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "idProducto": idProducto,
    "nombre": nombre,
    "descripcion": descripcion,
    "habilitado": habilitado,
    "tipo": tipo,
    "categoria": categoria,
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "cobeturas": List<dynamic>.from(cobeturas.map((x) => x)),
    "productosGuardados": List<dynamic>.from(productosGuardados.map((x) => x)),
    "reporteIncidentes": List<dynamic>.from(reporteIncidentes.map((x) => x)),
  };
}