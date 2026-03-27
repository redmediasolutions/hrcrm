class EmployeeFullModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  final String? position;
  final String? salary;

  final String? basicPay;
  final String? bonus;
  final String? pf;
  final String? tax;

  EmployeeFullModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.position,
    this.salary,
    this.basicPay,
    this.bonus,
    this.pf,
    this.tax,
  });

  factory EmployeeFullModel.fromJson(Map<String, dynamic> json) {
    return EmployeeFullModel(
      id: json['id'],
      name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position_held'],
      salary: json['salary_drawn'],
      basicPay: json['basic_pay'],
      bonus: json['Bonus'],
      pf: json['pf_deduction'],
      tax: json['professional_tax'],
    );
  }
}