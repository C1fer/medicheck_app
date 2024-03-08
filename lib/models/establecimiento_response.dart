import 'establecimiento.dart';

class EstablecimientoResponse {
  List<Establecimiento> data;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  EstablecimientoResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory EstablecimientoResponse.fromJson(Map<String, dynamic> json) {
    return EstablecimientoResponse(
      data: (json['data'] as List).map((item) => Establecimiento.fromJson(item)).toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
