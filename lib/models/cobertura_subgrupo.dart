import 'cobertura_grupo.dart';

class SubGrupoCobertura {
  int idSubGrupo;
  int idGrupo;
  String nombre;
  GrupoCobertura idGrupoNavigation;

  SubGrupoCobertura(
      {required this.idSubGrupo,
      required this.idGrupo,
      required this.nombre,
      required this.idGrupoNavigation});

  factory SubGrupoCobertura.fromJson(Map<String, dynamic> json) =>
      SubGrupoCobertura(
          idSubGrupo: json["idSubgrupo"],
          idGrupo: json["idGrupo"],
          nombre: json["descripcion"],
          idGrupoNavigation:
              GrupoCobertura.fromJson(json["idGrupoNavigation"]));
}
