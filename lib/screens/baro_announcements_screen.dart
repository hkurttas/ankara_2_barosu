import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/api_service.dart';

class BaroAnnouncementsScreen extends StatefulWidget {
  @override
  _BaroAnnouncementsScreenState createState() => _BaroAnnouncementsScreenState();
}

class _BaroAnnouncementsScreenState extends State<BaroAnnouncementsScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Announcement>> futureAnnouncements;

  @override
  void initState() {
    super.initState();
    futureAnnouncements = apiService.fetchAnnouncements(category: 'ilan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baro İlanlar'),
      ),
      body: FutureBuilder<List<Announcement>>(
        future: futureAnnouncements,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].date.toString()),
                    onTap: () {},
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
    );
  }
}