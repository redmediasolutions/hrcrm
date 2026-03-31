class OfficeUseModel {
  final int? employeeId;

  final String? receivedDate;
  final String? checkedByDate;
  final String? dateOfJoining;

  final bool panCard;
  final bool aadhaarCard;
  final bool experienceCertificate;
  final bool salaryProof;
  final bool educationalCertificates;
  final bool bankPassbook;
  final bool recommendationLetter;
  final bool medicalCertificate;

  final bool approved;
  final bool notApproved;

  final String? employeeIdNumber;

  OfficeUseModel({
    this.employeeId,
    this.receivedDate,
    this.checkedByDate,
    this.dateOfJoining,
    this.panCard = false,
    this.aadhaarCard = false,
    this.experienceCertificate = false,
    this.salaryProof = false,
    this.educationalCertificates = false,
    this.bankPassbook = false,
    this.recommendationLetter = false,
    this.medicalCertificate = false,
    this.approved = false,
    this.notApproved = false,
    this.employeeIdNumber,
  });

  factory OfficeUseModel.fromJson(Map<String, dynamic> json) {
    return OfficeUseModel(
      employeeId: json['employee_id'],
      receivedDate: json['received_date'],
      checkedByDate: json['checked_by_date'],
      dateOfJoining: json['date_of_joining'],

      panCard: json['pan_card'] == 1,
      aadhaarCard: json['aadhaar_card'] == 1,
      experienceCertificate: json['experience_certificate'] == 1,
      salaryProof: json['salary_proof'] == 1,
      educationalCertificates: json['educational_certificates'] == 1,
      bankPassbook: json['bank_passbook'] == 1,
      recommendationLetter: json['recommendation_letter'] == 1,
      medicalCertificate: json['medical_certificate'] == 1,

      approved: json['approved'] == 1,
      notApproved: json['not_approved'] == 1,

      employeeIdNumber: json['employee_id_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "received_date": receivedDate,
      "checked_by_date": checkedByDate,
      "date_of_joining": dateOfJoining,

      "pan_card": panCard,
      "aadhaar_card": aadhaarCard,
      "experience_certificate": experienceCertificate,
      "salary_proof": salaryProof,
      "educational_certificates": educationalCertificates,
      "bank_passbook": bankPassbook,
      "recommendation_letter": recommendationLetter,
      "medical_certificate": medicalCertificate,

      "approved": approved,
      "not_approved": notApproved,

      "employee_id_number": employeeIdNumber,
    };
  }
}