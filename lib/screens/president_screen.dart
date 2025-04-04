import 'package:flutter/material.dart';

class PresidentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baro Başkanı'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.network(
                'https://medya.barobirlik.org.tr/BaroWebSite/uploads/620/BA%C5%9EKAN%2FBASKAN.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'AV. GÖKHAN AĞDEMİR\nBARO BAŞKANI',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}