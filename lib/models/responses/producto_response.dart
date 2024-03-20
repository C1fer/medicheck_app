
import '../producto.dart';

class ProductoResponse {
  List<Producto> data;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  ProductoResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory ProductoResponse.fromJson(Map<String, dynamic> json) {
    return ProductoResponse(
      data: (json['data'] as List).map((item) => Producto.fromJson(item["idProductoNavigation"])).toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
