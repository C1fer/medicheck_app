import '../plan.dart';

class PlanResponse {
  List<Plan> data;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  PlanResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      data: (json['data'] as List).map((item) => Plan.fromJson(item)).toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
