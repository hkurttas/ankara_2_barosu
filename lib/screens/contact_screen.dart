import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Contact>> futureContacts;

  @override
  void initState() {
    super.initState();
    futureContacts = apiService.fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolluk Kuvvet Birimleri'),
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
        child: FutureBuilder<List<Contact>>(
          future: futureContacts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // İlçeleri A-Z sıralı hale getir
              final contacts = snapshot.data!;
              final groupedContacts = <String, List<Contact>>{};
              for (var contact in contacts) {
                if (!groupedContacts.containsKey(contact.name.split(' - ')[0])) {
                  groupedContacts[contact.name.split(' - ')[0]] = [];
                }
                groupedContacts[contact.name.split(' - ')[0]]!.add(contact);
              }

              final sortedDistricts = groupedContacts.keys.toList()..sort();

              return ListView.builder(
                itemCount: sortedDistricts.length,
                itemBuilder: (context, index) {
                  final district = sortedDistricts[index];
                  final districtContacts = groupedContacts[district]!;

                  // İlçeye bağlı karakolları ve amirlikleri sıralı hale getir
                  districtContacts.sort((a, b) => a.name.compareTo(b.name));

                  return ExpansionTile(
                    title: Text(
                      district,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    children: districtContacts.map((contact) {
                      return ListTile(
                        title: Text(
                          contact.name.split(' - ').length > 1
                              ? contact.name.split(' - ')[1]
                              : contact.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (contact.phone.isNotEmpty)
                              Text('Telefon: ${contact.phone}'),
                            if (contact.mobile.isNotEmpty)
                              Text('Mobil: ${contact.mobile}'),
                            if (contact.fax.isNotEmpty) Text('Faks: ${contact.fax}'),
                            if (contact.email.isNotEmpty)
                              Text('E-posta: ${contact.email}'),
                            if (contact.website.isNotEmpty)
                              Text('Web: ${contact.website}'),
                          ],
                        ),
                      );
                    }).toList(),
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