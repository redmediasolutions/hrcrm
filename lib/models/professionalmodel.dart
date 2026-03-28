class ProfessionalModel {
  final String? positionHeld;
  final String? employerName;
  final String? salaryDrawn;

  ProfessionalModel({
    this.positionHeld,
    this.employerName,
    this.salaryDrawn,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      positionHeld: json['position_held'],
      employerName: json['employer_name'],
      salaryDrawn: json['salary_drawn']?.toString(),
    );
  }
}