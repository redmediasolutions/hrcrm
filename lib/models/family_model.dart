class FamilyModel {
  final int id;
  final String? name;
  final String? relation;
  final int? age;

  FamilyModel({
    required this.id,
    this.name,
    this.relation,
    this.age,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      name: json['name'],
      relation: json['relation'],
      age: json['age'],
    );
  }

  /// 🔥 Convert LIST
  static List<FamilyModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => FamilyModel.fromJson(e)).toList();
  }
}