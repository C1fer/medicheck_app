import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  int idUsuario;
  String rol;
  String nombre;
  String apellidos;
  String correo;
  String telefono;
  String habilitado;
  DateTime fechaNacimiento;
  DateTime fechaRegistro;
  String clave;
  String noDocumento;
  String tipoDocumento;

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
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json["id_usuario"],
    rol: json["rol"],
    nombre: json["nombre"],
    apellidos: json["apellidos"],
    correo: json["correo"],
    telefono: json["telefono"],
    habilitado: json["habilitado"],
    fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
    fechaRegistro: DateTime.parse(json["fecha_registro"]),
    clave: json["clave"],
    noDocumento: json["no_documento"],
    tipoDocumento: json["tipo_documento"],
  );

  Map<String, dynamic> toJson() => {
    "id_usuario": idUsuario,
    "rol": rol,
    "nombre": nombre,
    "apellidos": apellidos,
    "correo": correo,
    "telefono": telefono,
    "habilitado": habilitado,
    "fecha_nacimiento": fechaNacimiento.toIso8601String(),
    "fecha_registro": fechaRegistro.toIso8601String(),
    "clave": clave,
    "no_documento": noDocumento,
    "tipo_documento": tipoDocumento,
  };
}
