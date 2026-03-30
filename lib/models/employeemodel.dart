class EmployeeModel {
  final int id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? nationality;
  final String? onboardingDate;
  final String? createdAt;

  // 🔥 NEW FIELD
  final int? department;

  EmployeeModel({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.nationality,
    this.onboardingDate,
    this.createdAt,
    this.department, // ✅ add
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      nationality: json['nationality'],
      onboardingDate: json['onboarding_date'],
      createdAt: json['created_at'],

      // 🔥 IMPORTANT
      department: json['department'],
    );
  }
}