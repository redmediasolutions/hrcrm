class FamilyModel {
  final int? id;
  final int? employeeId;
  final int? tenantId;

  final String? fatherName;
  final String? fatherContact;

  final String? motherName;
  final String? motherContact;

  final String? spouseName;
  final String? spouseContact;

  FamilyModel({
    this.id,
    this.employeeId,
    this.tenantId,
    this.fatherName,
    this.fatherContact,
    this.motherName,
    this.motherContact,
    this.spouseName,
    this.spouseContact,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      employeeId: json['employee_id'],
      tenantId: json['tenant_id'],

      fatherName: json['father_name']?.toString(),
      fatherContact: json['father_contact']?.toString(),

      motherName: json['mother_name']?.toString(),
      motherContact: json['mother_contact']?.toString(),

      spouseName: json['spouse_name']?.toString(),
      spouseContact: json['spouse_contact']?.toString(),
    );
  }

  /// ✅ SAFE PARSER (NOW RETURNS SINGLE OBJECT)
  static FamilyModel fromResponse(dynamic json) {
    if (json == null) return FamilyModel();
    if (json is Map<String, dynamic>) {
      return FamilyModel.fromJson(json);
    }
    return FamilyModel();
  }
}