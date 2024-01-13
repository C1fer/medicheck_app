import 'dart:convert';

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));

String planToJson(Plan data) => json.encode(data.toJson());

class Plan {
  int idPlan;
  String descripcion;
  int idAseguradora;
  DateTime fechaRegistro;
  List<dynamic> cobeturas;
  dynamic idAseguradoraNavigation;
  List<dynamic> usuarioPlans;

  Plan({
    required this.idPlan,
    required this.descripcion,
    required this.idAseguradora,
    required this.fechaRegistro,
    required this.cobeturas,
    required this.idAseguradoraNavigation,
    required this.usuarioPlans,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    idPlan: json["idPlan"],
    descripcion: json["descripcion"],
    idAseguradora: json["idAseguradora"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    cobeturas: List<dynamic>.from(json["cobeturas"].map((x) => x)),
    idAseguradoraNavigation: json["idAseguradoraNavigation"],
    usuarioPlans: List<dynamic>.from(json["usuarioPlans"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "idPlan": idPlan,
    "descripcion": descripcion,
    "idAseguradora": idAseguradora,
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "cobeturas": List<dynamic>.from(cobeturas.map((x) => x)),
    "idAseguradoraNavigation": idAseguradoraNavigation,
    "usuarioPlans": List<dynamic>.from(usuarioPlans.map((x) => x)),
  };
}
