import 'dart:convert';
import 'dart:ffi';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  int idUsuario;
  String? rol;
  String? nombre;
  String? apellidos;
  String? correo;
  String? telefono;
  bool habilitado;
  DateTime fechaNacimiento;
  DateTime fechaRegistro;
  String? clave;
  String? noDocumento;
  String? tipoDocumento;
  List<dynamic> productosGuardados;
  List<dynamic> usuarioPlans;


  Usuario({
    required this.idUsuario,
    required this.rol,
    required this.nombre,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.habilitado,
    required this.fechaNacimiento,
    required this.fechaRegistro,
    required this.clave,
    required this.noDocumento,
    required this.tipoDocumento,
    required this.productosGuardados,
    required this.usuarioPlans
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json["idUsuario"],
    rol: json["rol"],
    nombre: json["nombre"],
    apellidos: json["apellidos"],
    correo: json["correo"],
    telefono: json["telefono"],
    habilitado: json["habilitado"],
    fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
    fechaRegistro: DateTime.parse(json["fechaRegistro"]),
    clave: json["clave"],
    noDocumento: json["noDocumento"],
    tipoDocumento: json["tipoDocumento"],
    productosGuardados: List<dynamic>.from(json["productosGuardados"].map((x) => x)),
    usuarioPlans: List<dynamic>.from(json["usuarioPlans"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "rol": rol,
    "nombre": nombre,
    "apellidos": apellidos,
    "correo": correo,
    "telefono": telefono,
    "habilitado": habilitado,
    "fechaNacimiento": fechaNacimiento.toIso8601String(),
    "fechaRegistro": fechaRegistro.toIso8601String(),
    "clave": clave,
    "noDocumento": noDocumento,
    "tipoDocumento": tipoDocumento,
    "productosGuardados": List<dynamic>.from(productosGuardados.map((x) => x)),
    "usuarioPlans": List<dynamic>.from(usuarioPlans.map((x) => x)),
  };
}
