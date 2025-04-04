import 'package:flutter/material.dart';
import '../models/representative.dart';
import '../services/api_service.dart';

class RepresentativesScreen extends StatefulWidget {
  @override
  _RepresentativesScreenState createState() => _RepresentativesScreenState();
}

class _RepresentativesScreenState extends State<RepresentativesScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Representative>> futureRepresentatives;

  @override
  void initState() {
    super.initState();
    futureRepresentatives = apiService.fetchRepresentatives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlçe Temsilcileri'),
        backgroundColor: const Color(0xFF0052CC), // Baro mavisi
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://medya.barobirlik.org.tr/barowebsite/uploads/620/LOGO/Ankara-2-Nolu-Baro-Logo---2-(1).png'),
            fit: BoxFit.cover,
            opacity: 0.1, // Saydamlık
          ),
        ),
        child: FutureBuilder<List<Representative>>(
          future: futureRepresentatives,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final representatives = snapshot.data!;
              // İlçeleri A-Z sıralı hale getir
              representatives.sort((a, b) => a.location.compareTo(b.location));

              return ListView.builder(
                itemCount: representatives.length,
                itemBuilder: (context, index) {
                  final representative = representatives[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Fotoğraf yoksa placeholder
                        ),
                      ),
                      title: Text(
                        representative.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        representative.location,
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