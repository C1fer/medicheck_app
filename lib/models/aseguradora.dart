class Aseguradora {
  int idAseguradora;
  String nombre;
  String? direccion;
  String? telefono;
  String? correo;
  String? sitioWeb;
  DateTime fechaRegistro;

  Aseguradora({
    required this.idAseguradora,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.sitioWeb,
    required this.fechaRegistro,
  });

  factory Aseguradora.fromJson(Map<String, dynamic> json) => Aseguradora(
        idAseguradora: json["idAseguradora"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        correo: json["correo"],
        sitioWeb: json["sitioWeb"],
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      );

}
