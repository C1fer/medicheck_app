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
    idCobertura: json["IdCobertura"],
    idProducto: json["IdProducto"],
    idPlan: json["IdPlan"],
    cubre: json["Cubre"],
    porcentaje: json["Porcentaje"],
    fechaVencimiento: DateTime.parse(json["FechaVencimiento"]),
    fechaRegistro: DateTime.parse(json["FechaRegistro"]),
    idPlanNavigation: json["IdPlanNavigation"],
    idProductoNavigation: Producto.fromJson(json["IdProductoNavigation"]),
  );

  Map<String, dynamic> toJson() => {
    "IdCobertura": idCobertura,
    "IdProducto": idProducto,
    "IdPlan": idPlan,
    "Cubre": cubre,
    "Porcentaje": porcentaje,
    "FechaVencimiento": fechaVencimiento!.toIso8601String(),
    "FechaRegistro": fechaRegistro.toIso8601String(),
    "IdPlanNavigation": idPlanNavigation?.toJson(),
    "IdProductoNavigation": idProductoNavigation.toJson(),
  };
}