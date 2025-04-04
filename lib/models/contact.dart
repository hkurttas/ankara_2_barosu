class Contact {
  final int id;
  final String name;
  final String phone;
  final String mobile;
  final String fax;
  final String email;
  final String website;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.mobile,
    required this.fax,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      mobile: json['mobile'],
      fax: json['fax'],
      email: json['email'],
      website: json['website'],
    );
  }
}