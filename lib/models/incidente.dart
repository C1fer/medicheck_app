import 'plan.dart';
import 'producto.dart';
import 'usuario.dart';
import 'establecimiento.dart';

class Incidente {
  int idIncidente;
  String descripcion;
  String estado;
  DateTime? fechaIncidente;
  DateTime fechaRegistro;

  Establecimiento establecimientoNavigation;
  Plan? planNavigation;
  Producto productoNavigation;
  Usuario? usuarioNavigation;

  Incidente(
      {required this.idIncidente,
      required this.descripcion,
      required this.estado,
      required this.fechaIncidente,
      required this.fechaRegistro,
      required this.establecimientoNavigation,
      required this.planNavigation,
      required this.productoNavigation,
      required this.usuarioNavigation});

  factory Incidente.fromJson(Map<String, dynamic> json) =>
      Incidente(
          idIncidente: json["idIncidente"],
          descripcion: json["descripcion"],
          estado: json["estado"],
          fechaIncidente: json["fechaIncidente"],
          fechaRegistro: DateTime.parse(json["fechaRegistro"]),
          establecimientoNavigation: Establecimiento.fromJson(json["idEstablecimientoNavigation"]),
          planNavigation: null,
          productoNavigation: Producto.fromJson(json["idProductoNavigation"] ),
          usuarioNavigation: null);
}
