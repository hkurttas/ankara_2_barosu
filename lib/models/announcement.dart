class Announcement {
  final int id;
  final String title;
  final DateTime date;
  final String category;

  Announcement({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']).toLocal(),
      category: json['category'],
    );
  }
}