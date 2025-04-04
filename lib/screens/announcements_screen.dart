import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/api_service.dart';

class AnnouncementsScreen extends StatefulWidget {
  final String category;

  const AnnouncementsScreen({required this.category});

  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Announcement>> futureAnnouncements;

  @override
  void initState() {
    super.initState();
    futureAnnouncements = apiService.fetchAnnouncements(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == 'duyuru' ? 'Duyurular' : 'Baro İlanlar'),
        backgroundColor: const Color(0xFF0052CC),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://medya.barobirlik.org.tr/barowebsite/uploads/620/LOGO/Ankara-2-Nolu-Baro-Logo---2-(1).png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: FutureBuilder<List<Announcement>>(
          future: futureAnnouncements,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final announcement = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        announcement.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '${announcement.date.day}/${announcement.date.month}/${announcement.date.year}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}