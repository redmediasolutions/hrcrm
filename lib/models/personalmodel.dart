class PersonalModel {
  final String? fullName;
  final String? dob;
  final String? gender;

  PersonalModel({
    this.fullName,
    this.dob,
    this.gender,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) {
    return PersonalModel(
      fullName: json['full_name'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }
}