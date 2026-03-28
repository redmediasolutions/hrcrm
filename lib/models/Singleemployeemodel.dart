class SingleEmployeeModel {
  final String fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? positionHeld;
  final String? salaryDrawn;
  final String? employerName;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? correspondenceAddress;
  final String? permanentAddress;

  SingleEmployeeModel({
    required this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.positionHeld,
    this.salaryDrawn,
    this.employerName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.correspondenceAddress,
    this.permanentAddress,
  });

  factory SingleEmployeeModel.fromJson(Map<String, dynamic> json) {
    return SingleEmployeeModel(
      fullName: json['full_name'] ?? '',
      email: json['contact_email'] ?? json['email'],
      phone: json['contact_phone'] ?? json['phone'],
      gender: json['gender'],
      dob: json['dob'],
      positionHeld: json['position_held'],
      salaryDrawn: json['salary_drawn']?.toString(),
      employerName: json['employer_name'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      correspondenceAddress: json['correspondence_address'],
      permanentAddress: json['permanent_address'],
    );
  }
}