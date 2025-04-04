import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';
import '../models/announcement.dart';
import '../models/representative.dart';
import '../models/event.dart';
import '../models/note.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Contact>> fetchContacts() async {
    final response = await http.get(Uri.parse('$baseUrl/contacts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Event.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Announcement>> fetchAnnouncements({String? category}) async {
    final uri = category != null
        ? Uri.parse('$baseUrl/announcements?category=$category')
        : Uri.parse('$baseUrl/announcements');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Announcement.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  Future<List<Representative>> fetchRepresentatives() async {
    final response = await http.get(Uri.parse('$baseUrl/representatives'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Representative.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load representatives');
    }
  }

  Future<List<Note>> fetchNotes({DateTime? noteDate}) async {
    final uri = noteDate != null
        ? Uri.parse('$baseUrl/notes?note_date=${noteDate.toIso8601String().split('T')[0]}')
        : Uri.parse('$baseUrl/notes');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Note.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> addNote(Note note) async {
    print('API\'ye gönderilen tarih: ${note.noteDate}');
    print('API\'ye gönderilen JSON: ${json.encode(note.toJson())}');

    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(note.toJson()),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add note');
    }
  }

  Future<Note> updateNote(Note note) async {
    print('API\'ye gönderilen tarih (güncelleme): ${note.noteDate}');
    print('API\'ye gönderilen JSON (güncelleme): ${json.encode(note.toJson())}');

    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(note.toJson()),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}