class PersonalModel {
  final String? dob;
  final String? motherTongue;
  final String? bloodGroup;
  final String? maritalStatus;
  final String? spouseName;
  final String? aadhaarNo;
  final String? panNo;
  final String? disabilityInfo;

  PersonalModel({
    this.dob,
    this.motherTongue,
    this.bloodGroup,
    this.maritalStatus,
    this.spouseName,
    this.aadhaarNo,
    this.panNo,
    this.disabilityInfo,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) {
    return PersonalModel(
      dob: json['dob'],
      motherTongue: json['mother_tongue'],
      bloodGroup: json['blood_group'],
      maritalStatus: json['marital_status'],
      spouseName: json['spouse_name'],
      aadhaarNo: json['aadhaar_no'],
      panNo: json['pan_no'],
      disabilityInfo: json['disability_info'],
    );
  }
}