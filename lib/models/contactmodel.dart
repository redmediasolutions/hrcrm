class ContactModel {
  final String? email;
  final String? phone;
  final String? address;

  ContactModel({
    this.email,
    this.phone,
    this.address,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: json['email'],
      phone: json['phone'],
      address: json['correspondence_address'],
    );
  }
}