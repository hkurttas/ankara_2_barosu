import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(contact.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tel: ${contact.phone}'),
            Text('Mobil: ${contact.mobile}'),
            Text('Faks: ${contact.fax}'),
            Text('E-posta: ${contact.email}'),
            Text('Web: ${contact.website}'),
          ],
        ),
      ),
    );
  }
}