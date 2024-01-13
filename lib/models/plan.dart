import 'dart:convert';

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));

String planToJson(Plan data) => json.encode(data.toJson());

class Plan {
  int idPlan;
  String descripcion;
  int idAseguradora;
  String fechaRegistro;
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
    idPlan: json["IdPlan"],
    descripcion: json["Descripcion"],
    idAseguradora: json["IdAseguradora"],
    fechaRegistro: json["FechaRegistro"],
    cobeturas: json["Coberturas"] != null ? List<dynamic>.from(json["Coberturas"].map((x) => x)) : [],
    idAseguradoraNavigation: json["IdAseguradoraNavigation"],
    usuarioPlans: json["UsuarioPlans"] != null ? List<dynamic>.from(json["UsuarioPlans"].map((x) => x)) : [],
  );

  Map<String, dynamic> toJson() => {
    "IdPlan": idPlan,
    "Descripcion": descripcion,
    "IdAseguradora": idAseguradora,
    "FechaRegistro": fechaRegistro,
    "Cobeturas": List<dynamic>.from(cobeturas.map((x) => x)),
    "IdAseguradoraNavigation": idAseguradoraNavigation,
    "UsuarioPlans": List<dynamic>.from(usuarioPlans.map((x) => x)),
  };
}
