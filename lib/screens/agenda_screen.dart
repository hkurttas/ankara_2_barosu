import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Event>> futureEvents;
  late Future<List<Note>> futureNotes;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  Map<DateTime, List<Note>> _notes = {};
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
    _loadNotes();
  }

  void _loadEvents() {
    futureEvents = apiService.fetchEvents();
    futureEvents.then((events) {
      setState(() {
        _events = {};
        for (var event in events) {
          final eventDate = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day);
          if (_events[eventDate] == null) {
            _events[eventDate] = [];
          }
          _events[eventDate]!.add(event.title);
        }
      });
    });
  }

  void _loadNotes() {
    futureNotes = apiService.fetchNotes();
    futureNotes.then((notes) {
      setState(() {
        _notes = {};
        for (var note in notes) {
          final noteDate = DateTime(note.noteDate.year, note.noteDate.month, note.noteDate.day);
          print('Not tarihi: ${note.noteDate}, Normalleştirilmiş tarih: $noteDate');
          if (_notes[noteDate] == null) {
            _notes[noteDate] = [];
          }
          _notes[noteDate]!.add(note);
        }
      });
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final eventDate = DateTime(day.year, day.month, day.day);
    List<dynamic> events = [];
    if (_events[eventDate] != null) {
      events.addAll(_events[eventDate]!);
    }
    if (_notes[eventDate] != null) {
      events.addAll(_notes[eventDate]!.map((note) => note.title));
    }
    return events;
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _descriptionController.clear();

    print('Seçilen tarih: ${_selectedDay ?? _focusedDay}');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Not Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  final newNote = Note(
                    id: 0,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    noteDate: _selectedDay ?? _focusedDay,
                  );
                  try {
                    await apiService.addNote(newNote);
                    _loadNotes();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not eklenemedi: $e')),
                    );
                  }
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(Note note) {
    _titleController.text = note.title;
    _descriptionController.text = note.description ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  final updatedNote = Note(
                    id: note.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    noteDate: note.noteDate,
                  );
                  try {
                    await apiService.updateNote(updatedNote);
                    _loadNotes();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not güncellenemedi: $e')),
                    );
                  }
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(Note note) async {
    try {
      await apiService.deleteNote(note.id);
      _loadNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not silinemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajanda'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([futureEvents, futureNotes]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final selectedDate = _selectedDay ?? _focusedDay;
                  final events = _getEventsForDay(selectedDate);
                  final notesForDay = _notes[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)] ?? [];

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: events.length + notesForDay.length,
                          itemBuilder: (context, index) {
                            if (index < events.length) {
                              return ListTile(
                                title: Text(events[index]),
                                leading: const Icon(Icons.event, color: Colors.blue),
                              );
                            } else {
                              final noteIndex = index - events.length;
                              final note = notesForDay[noteIndex];
                              return ListTile(
                                title: Text(note.title),
                                subtitle: note.description != null ? Text(note.description!) : null,
                                leading: const Icon(Icons.note, color: Colors.orange),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _showEditNoteDialog(note),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteNote(note),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _showAddNoteDialog,
                          child: const Text('Not Ekle'),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}