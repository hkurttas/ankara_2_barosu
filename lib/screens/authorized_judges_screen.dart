import 'package:flutter/material.dart';

class AuthorizedJudgesScreen extends StatelessWidget {
  final List<Map<String, String>> judges = [
    {'name': 'Hakim Ahmet Yılmaz', 'court': 'Ankara 1. Ağır Ceza Mahkemesi'},
    {'name': 'Hakim Ayşe Demir', 'court': 'Ankara 2. Asliye Hukuk Mahkemesi'},
    {'name': 'Hakim Mehmet Kaya', 'court': 'Ankara 3. Sulh Hukuk Mahkemesi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İzinli Hakimler'),
      ),
      body: ListView.builder(
        itemCount: judges.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(judges[index]['name']!),
            subtitle: Text(judges[index]['court']!),
            onTap: () {},
          );
        },
      ),
    );
  }
}