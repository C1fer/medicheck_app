import 'cobertura_grupo.dart';

class SubGrupoCobertura {
  int idSubGrupo;
  String nombre;
  GrupoCobertura idGrupoNavigation;

  SubGrupoCobertura(
      {required this.idSubGrupo,
      required this.nombre,
      required this.idGrupoNavigation});

  factory SubGrupoCobertura.fromJson(Map<String, dynamic> json) =>
      SubGrupoCobertura(
          idSubGrupo: json["idSubgrupo"],
          nombre: json["descripcion"],
          idGrupoNavigation:
              GrupoCobertura.fromJson(json["idGrupoNavigation"]));
}
