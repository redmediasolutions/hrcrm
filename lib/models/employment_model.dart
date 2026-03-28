class EmploymentModel {
  final int id;
  final String? employerName;
  final String? positionHeld;
  final String? salaryDrawn;
  final String? startDate;
  final String? endDate;

  EmploymentModel({
    required this.id,
    this.employerName,
    this.positionHeld,
    this.salaryDrawn,
    this.startDate,
    this.endDate,
  });

  factory EmploymentModel.fromJson(Map<String, dynamic> json) {
    return EmploymentModel(
      id: json['id'],
      employerName: json['employer_name'],
      positionHeld: json['position_held'],
      salaryDrawn: json['salary_drawn']?.toString(),
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  /// 🔥 Convert LIST (VERY IMPORTANT)
  static List<EmploymentModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => EmploymentModel.fromJson(e)).toList();
  }
}