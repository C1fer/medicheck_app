import 'dart:convert';

import 'package:medicheck/models/aseguradora.dart';

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));

String planToJson(Plan data) => json.encode(data.toJson());

class Plan {
  int idPlan;
  String descripcion;
  int idAseguradora;
  DateTime fechaRegistro;
  List<dynamic>? cobeturas;
  Aseguradora? idAseguradoraNavigation;
  List<dynamic>? personaPlans;
  List<dynamic>? reporteIncidentes;
  List<dynamic>? usuarioPlans;

  Plan({
    required this.idPlan,
    required this.descripcion,
    required this.idAseguradora,
    required this.fechaRegistro,
    required this.cobeturas,
    required this.idAseguradoraNavigation,
    required this.personaPlans,
    required this.reporteIncidentes,
    required this.usuarioPlans,
  });


  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    idPlan: json["idPlan"],
    descripcion: json["descripcion"],
    idAseguradora: json["idAseguradora"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    cobeturas: json["coberturas"],
    idAseguradoraNavigation: json["idAseguradoraNavigation"] != null ? Aseguradora.fromJson(json["idAseguradoraNavigation"]) : null,
    personaPlans: json["UsuarioPlans"],
    reporteIncidentes: json["reporteIncidentes"],
    usuarioPlans: json["UsuarioPlans"],
  );

  Map<String, dynamic> toJson() => {
    "idPlan": idPlan,
    "descripcion": descripcion,
    "idAseguradora": idAseguradora,
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "cobeturas": cobeturas != null ? List<dynamic>.from(cobeturas!.map((x) => x)) : null,
    "idAseguradoraNavigation": idAseguradoraNavigation?.toJson(),
    "personaPlans": cobeturas != null ? List<dynamic>.from(personaPlans!.map((x) => x)) : null,
    "reporteIncidentes": cobeturas != null ? List<dynamic>.from(reporteIncidentes!.map((x) => x)) : null,
    "usuarioPlans": usuarioPlans != null ? List<dynamic>.from(usuarioPlans!.map((x) => x)) : null,
  };
}
