import 'aseguradora.dart';
import 'regimen.dart';

class Plan {
  int idPlan;
  String descripcion;
  Aseguradora idAseguradoraNavigation;
  Regimen idRegimenNavigation;
  DateTime fechaRegistro;

  Plan(
      {required this.idPlan,
      required this.descripcion,
      required this.fechaRegistro,
      required this.idAseguradoraNavigation,
      required this.idRegimenNavigation});

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
      idPlan: json["idPlan"],
      descripcion: json["descripcion"],
      fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      idAseguradoraNavigation: Aseguradora.fromJson(json["idAseguradoraNavigation"]),
      idRegimenNavigation: Regimen.fromJson(json["idRegimenNavigation"]));
}
