import 'package:red_hrcrm/models/employeemodel.dart';
import 'package:red_hrcrm/models/paginationmodel.dart';

class PaginatedEmployeeResponse {
  final List<EmployeeModel> data;
  final Pagination pagination;

  PaginatedEmployeeResponse({
    required this.data,
    required this.pagination,
  });

  factory PaginatedEmployeeResponse.fromJson(
      Map<String, dynamic> json) {
    return PaginatedEmployeeResponse(
      data: (json['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}