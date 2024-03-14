import 'dart:convert';

import 'plan.dart';
import 'producto.dart';
import 'usuario.dart';
import 'establecimiento.dart';

ReporteIncidente reporteIncidentefromJson(String str) =>
    ReporteIncidente.fromJson(json.decode(str));

class ReporteIncidente {
  int idIncidente;
  int idUsuario;
  int idPlan;
  int idEstablecimiento;
  int idProducto;
  String descripcion;
  String estado;
  DateTime? fechaIncidente;
  DateTime fechaRegistro;
  Establecimiento establecimientoNavigation;
  Plan planNavigation;
  Producto productoNavigation;
  Usuario usuarioNavigation;

  ReporteIncidente(
      {required this.idIncidente,
      required this.idUsuario,
      required this.idPlan,
      required this.idEstablecimiento,
      required this.idProducto,
      required this.descripcion,
      required this.estado,
      required this.fechaIncidente,
      required this.fechaRegistro,
      required this.establecimientoNavigation,
      required this.planNavigation,
      required this.productoNavigation,
      required this.usuarioNavigation});

  factory ReporteIncidente.fromJson(Map<String, dynamic> json) =>
      ReporteIncidente(
          idIncidente: json["idIncidente"],
          idUsuario: json["idUsuario"],
          idPlan: json["idPlan"],
          idEstablecimiento: json["idEstablecimiento"],
          idProducto: json["idProducto"],
          descripcion: json["descripcion"],
          estado: json["estado"],
          fechaIncidente: json["fechaIncidente"],
          fechaRegistro: DateTime.parse(json["fechaRegisro"]),
          establecimientoNavigation: json["idEstablecimientoNavegation"],
          planNavigation: json["idPlanNavegation"],
          productoNavigation: json["idProductoNavegation"],
          usuarioNavigation: json["idUsuarioNavegation"]);
}
