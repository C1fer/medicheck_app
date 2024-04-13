class GrupoCobertura {
  int id;
  String nombre;

  GrupoCobertura({required this.id, required this.nombre});

  factory GrupoCobertura.fromJson(Map<String, dynamic> json) =>
      GrupoCobertura(id: json["id"], nombre: json["descripcion"]);
}
