import '../incident.dart';

class ReporteResponse {
  List<ReporteIncidente> data;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  ReporteResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory ReporteResponse.fromJson(Map<String, dynamic> json) {
    return ReporteResponse(
      data: (json['data'] as List)
          .map((item) => ReporteIncidente.fromJson(item))
          .toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
