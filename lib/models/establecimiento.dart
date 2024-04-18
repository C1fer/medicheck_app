class Establecimiento {
  int idEstablecimiento;
  String nombre;
  String categoria;
  String? direccion;
  String? telefono;
  String? correo;
  double latitud;
  double longitud;
  String googlePlaceID;
  DateTime fechaRegistro;

  Establecimiento({
    required this.idEstablecimiento,
    required this.nombre,
    required this.categoria,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.latitud,
    required this.longitud,
    required this.googlePlaceID,
    required this.fechaRegistro,
  });

  factory Establecimiento.fromJson(Map<String, dynamic> json) => Establecimiento(
    idEstablecimiento: json["idEstablecimiento"],
    nombre: json["nombre"],
    categoria: json["categoria"],
    direccion: json["direccion"],
    telefono: json["telefono"],
    correo: json["correo"],
    latitud: json["latitud"],
    longitud: json["longitud"],
    googlePlaceID: json["googlePlaceId"],
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
  );
}
