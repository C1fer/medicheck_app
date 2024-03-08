import 'dart:convert';
import 'plan.dart';
import 'producto.dart';


Cobertura coberturaFromJson(String str) => Cobertura.fromJson(json.decode(str));

String coberturaToJson(Cobertura data) => json.encode(data.toJson());

class Cobertura {
  int idCobertura;
  int idProducto;
  int idPlan;
  bool? cubre;
  int? porcentaje;
  DateTime? fechaVencimiento;
  DateTime fechaRegistro;
  Plan? idPlanNavigation;
  Producto idProductoNavigation;

  Cobertura({
    required this.idCobertura,
    required this.idProducto,
    required this.idPlan,
    required this.cubre,
    required this.porcentaje,
    required this.fechaVencimiento,
    required this.fechaRegistro,
    required this.idPlanNavigation,
    required this.idProductoNavigation,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) => Cobertura(
    idCobertura: json["idCobertura"],
    idProducto: json["idProducto"],
    idPlan: json["idPlan"],
    cubre: json["cubre"],
    porcentaje: json["porcentaje"],
    fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    idPlanNavigation: json["idPlanNavigation"],
    idProductoNavigation: Producto.fromJson(json["idProductoNavigation"]),
  );

  Map<String, dynamic> toJson() => {
    "idCobertura": idCobertura,
    "idProducto": idProducto,
    "idPlan": idPlan,
    "cubre": cubre,
    "porcentaje": porcentaje,
    "fechaVencimiento": fechaVencimiento!.toIso8601String(),
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "idPlanNavigation": idPlanNavigation?.toJson(),
    "idProductoNavigation": idProductoNavigation.toJson(),
  };
}