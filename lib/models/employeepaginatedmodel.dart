import 'package:red_hrcrm/models/employeemodel.dart';

class PaginatedEmployeeResponse {
  final List<EmployeeFullModel> data;
  final int total;
  final int page;
  final int totalPages;

  PaginatedEmployeeResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory PaginatedEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedEmployeeResponse(
      data: (json['data'] as List)
          .map((e) => EmployeeFullModel.fromJson(e))
          .toList(),
      total: json['pagination']['total'],
      page: json['pagination']['page'],
      totalPages: json['pagination']['totalPages'],
    );
  }
}