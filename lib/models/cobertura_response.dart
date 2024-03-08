import 'cobertura.dart';

class CoberturaResponse {
  List<Cobertura> data;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  CoberturaResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory CoberturaResponse.fromJson(Map<String, dynamic> json) {
    return CoberturaResponse(
      data: (json['data'] as List).map((item) => Cobertura.fromJson(item)).toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
