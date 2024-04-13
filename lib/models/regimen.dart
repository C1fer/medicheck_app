class Regimen {
  int id;
  String descripcion;

  Regimen({required this.id, required this.descripcion});

  factory Regimen.fromJson(Map<String, dynamic> json) =>
      Regimen(id: json["id"], descripcion: json["descripcion"]);
}
