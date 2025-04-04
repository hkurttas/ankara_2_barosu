class Note {
  final int id;
  final String title;
  final String? description;
  final DateTime noteDate;

  Note({
    required this.id,
    required this.title,
    this.description,
    required this.noteDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      noteDate: DateTime.parse(json['note_date']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final date = DateTime(noteDate.year, noteDate.month, noteDate.day);
    return {
      'title': title,
      'description': description,
      'note_date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    };
  }
}