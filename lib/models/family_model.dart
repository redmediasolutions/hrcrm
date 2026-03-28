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
      id: json['id'] ?? 0,
      name: json['name']?.toString(),
      relation: json['relation']?.toString(),
      age: json['age'] is int
          ? json['age']
          : int.tryParse(json['age']?.toString() ?? ''),
    );
  }

  /// ✅ SAFE LIST PARSER
  static List<FamilyModel> listFromJson(dynamic json) {
    if (json is List) {
      return json.map((e) => FamilyModel.fromJson(e)).toList();
    }
    return [];
  }
}