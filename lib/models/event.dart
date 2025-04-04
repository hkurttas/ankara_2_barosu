class Event {
  final int id;
  final String title;
  final DateTime eventDate;

  Event({
    required this.id,
    required this.title,
    required this.eventDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      eventDate: DateTime.parse(json['event_date']).toLocal(),
    );
  }
}