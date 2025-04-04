import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import '../widgets/contact_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Contact>> futureContacts;
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    futureContacts = apiService.fetchContacts();
    futureContacts.then((contacts) {
      setState(() {
        allContacts = contacts;
        filteredContacts = contacts;
      });
    });
  }

  void filterContacts(String query) {
    setState(() {
      filteredContacts = allContacts
          .where((contact) =>
          contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => filterContacts(value),
              decoration: InputDecoration(
                hintText: 'Arama...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Contact>>(
                future: futureContacts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return ContactCard(contact: filteredContacts[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Hata: ${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}