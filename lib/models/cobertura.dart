import 'plan.dart';
import 'producto.dart';
import 'cobertura_grupo.dart';
import 'cobertura_subgrupo.dart';

class Cobertura {
  int idCobertura;
  int porcentaje;
  DateTime? fechaVencimiento;
  DateTime fechaRegistro;
  bool isPDSS;
  bool? nivelAtencion1;
  bool? nivelAtencion2;
  bool? nivelAtencion3;
  double? coberturaTope;
  double? cuotaAfiliadoTope;
  GrupoCobertura idGrupoNavigation;
  SubGrupoCobertura idSubGrupoNavigation;
  Plan? idPlanNavigation;
  Producto idProductoNavigation;

  Cobertura({
    required this.idCobertura,
    required this.porcentaje,
    required this.fechaVencimiento,
    required this.fechaRegistro,
    required this.isPDSS,
    required this.nivelAtencion1,
    required this.nivelAtencion2,
    required this.nivelAtencion3,
    required this.coberturaTope,
    required this.cuotaAfiliadoTope,
    required this.idGrupoNavigation,
    required this.idSubGrupoNavigation,
    required this.idPlanNavigation,
    required this.idProductoNavigation,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) => Cobertura(
        idCobertura: json["idCobertura"],
        porcentaje: json["porcentaje"],
        fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
        isPDSS: json["isPdss"],
        nivelAtencion1: json["nivelAtencion1"],
        nivelAtencion2: json["nivelAtencion2"],
        nivelAtencion3: json["nivelAtencion3"],
        coberturaTope: json["coberturaTope"],
        cuotaAfiliadoTope: json["cuotaAfiliadoTope"],
        idGrupoNavigation: json["idGrupoNavigation"],
        idSubGrupoNavigation: json["idSubGrupoNavigation"],
        idPlanNavigation: json["idPlanNavigation"] != null
            ? Plan.fromJson(json["idPlanNavigation"])
            : null,
        idProductoNavigation: Producto.fromJson(json["idProductoNavigation"]),
      );
}
