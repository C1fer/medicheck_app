import 'dart:convert';

Aseguradora aseguradoraFromJson(String str) => Aseguradora.fromJson(json.decode(str));

String aseguradoraToJson(Aseguradora data) => json.encode(data.toJson());

class Aseguradora {
  int idAseguradora;
  String nombre;
  String? direccion;
  String? telefono;
  String? correo;
  String? sitioWeb;
  DateTime fechaRegistro;
  List<dynamic> establecimientoAseguradoras;
  List<dynamic> planes;

  Aseguradora({
    required this.idAseguradora,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.sitioWeb,
    required this.fechaRegistro,
    required this.establecimientoAseguradoras,
    required this.planes,
  });

  factory Aseguradora.fromJson(Map<String, dynamic> json) => Aseguradora(
    idAseguradora: json["idAseguradora"],
    nombre: json["nombre"],
    direccion: json["direccion"],
    telefono: json["telefono"],
    correo: json["correo"],
    sitioWeb: json["sitioWeb"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    establecimientoAseguradoras: List<dynamic>.from(json["establecimientoAseguradoras"].map((x) => x)),
    planes: List<dynamic>.from(json["planes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "idAseguradora": idAseguradora,
    "nombre": nombre,
    "direccion": direccion,
    "telefono": telefono,
    "correo": correo,
    "sitioWeb": sitioWeb,
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "establecimientoAseguradoras": List<dynamic>.from(establecimientoAseguradoras.map((x) => x)),
    "planes": List<dynamic>.from(planes.map((x) => x)),
  };
}
