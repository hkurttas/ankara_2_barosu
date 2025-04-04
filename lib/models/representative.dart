class Representative {
  final int id;
  final String name;
  final String location;

  Representative({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Representative.fromJson(Map<String, dynamic> json) {
    return Representative(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}