import 'dart:convert';

Establecimiento establecimientoFromJson(String str) => Establecimiento.fromJson(json.decode(str));

String establecimientoToJson(Establecimiento data) => json.encode(data.toJson());

class Establecimiento {
  int idEstablecimiento;
  String? nombre;
  String? categoria;
  String? direccion;
  String? telefono;
  String? correo;
  DateTime fechaRegistro;
  List<dynamic> establecimientoAseguradoras;
  List<dynamic> reporteIncidentes;

  Establecimiento({
    required this.idEstablecimiento,
    required this.nombre,
    required this.categoria,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.fechaRegistro,
    required this.establecimientoAseguradoras,
    required this.reporteIncidentes,
  });

  factory Establecimiento.fromJson(Map<String, dynamic> json) => Establecimiento(
    idEstablecimiento: json["idEstablecimiento"],
    nombre: json["nombre"],
    categoria: json["categoria"],
    direccion: json["direccion"],
    telefono: json["telefono"],
    correo: json["correo"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    establecimientoAseguradoras: [],
    reporteIncidentes: [],
  );

  Map<String, dynamic> toJson() => {
    "idEstablecimiento": idEstablecimiento,
    "nombre": nombre,
    "categoria": categoria,
    "direccion": direccion,
    "telefono": telefono,
    "correo": correo,
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "establecimientoAseguradoras": List<dynamic>.from(establecimientoAseguradoras.map((x) => x)),
    "reporteIncidentes": List<dynamic>.from(reporteIncidentes.map((x) => x)),
  };
}
