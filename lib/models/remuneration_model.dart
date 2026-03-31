import 'dart:convert';

class RemunerationModel {
  final int? id;
  final int? employeeId;
  final int? tenantId;

  // Earnings
  final double? basicPay;
  final double? hra;
  final double? overtime;
  final double? bonus; 

  // Deductions
  final double? loans;
  final double? advance;
  final double? lop;
  final double? pfDeduction;
  final double? esi;
  final double? professionalTax;

  final String? createdAt;

  RemunerationModel({
    this.id,
    this.employeeId,
    this.tenantId,
    this.basicPay,
    this.hra,
    this.overtime,
    this.bonus,
    this.loans,
    this.advance,
    this.lop,
    this.pfDeduction,
    this.esi,
    this.professionalTax,
    this.createdAt,
  });

  factory RemunerationModel.fromJson(Map<String, dynamic> json) {
  double parse(dynamic val) {
    if (val == null) return 0.0;
    return double.tryParse(val.toString()) ?? 0.0;
  }

  return RemunerationModel(
    id: json['id'],
    employeeId: json['employee_id'],
    tenantId: json['tenant_id'],
    basicPay: parse(json['basic_pay']),
    hra: parse(json['hra']),
    overtime: parse(json['overtime']),
    bonus: parse(json['bonus']), 
    loans: parse(json['loans']),
    advance: parse(json['advance']),
    lop: parse(json['lop']),
    pfDeduction: parse(json['pf_deduction']),
    esi: parse(json['esi']),
    professionalTax: parse(json['professional_tax']),
  );
}

Map<String, dynamic> toJson() {
  return {
    "employee_id": employeeId,
    "basic_pay": basicPay ?? 0,
    "hra": hra ?? 0,
    "overtime": overtime ?? 0,
    "bonus": bonus ?? 0, 
    "loans": loans ?? 0,
    "advance": advance ?? 0,
    "lop": lop ?? 0,
    "pf_deduction": pfDeduction ?? 0,
    "esi": esi ?? 0,
    "professional_tax": professionalTax ?? 0,
  };
}
}