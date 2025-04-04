import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'agenda_screen.dart';
import 'announcements_screen.dart';
import 'contact_screen.dart';
import 'representatives_screen.dart';
import 'profile_screen.dart';
import 'president_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Her kart için bir scale değeri tutmak için bir Map kullanıyoruz
  final Map<int, double> _scaleValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ankara 2 Nolu Barosu'),
        backgroundColor: const Color(0xFF0052CC), // Baro mavisi
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
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              0,
              'Duyurular',
              Icons.announcement,
                  () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnnouncementsScreen(category: 'duyuru')),
              ),
            ),
            _buildCard(
              context,
              1,
              'Baro İlanlar',
              Icons.message,
                  () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnnouncementsScreen(category: 'ilan')),
              ),
            ),
            _buildCard(
              context,
              2,
              'Kolluk Kuvvet Birimleri',
              Icons.phone,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              ),
            ),
            _buildCard(
              context,
              3,
              'İlçe Temsilcileri',
              Icons.person,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RepresentativesScreen()),
              ),
            ),
            _buildCard(
              context,
              4,
              'Ajanda',
              Icons.calendar_today,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen()),
              ),
            ),
            _buildCard(
              context,
              5,
              'Baro Web Sitesi',
              Icons.web,
                  () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: 'https://www.ankara2nolubarosu.org.tr/',
                    title: 'Baro Web Sitesi',
                  ),
                ),
              ),
            ),
            _buildCard(
              context,
              6,
              'Baro Başkanı',
              Icons.person_pin,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PresidentScreen()),
              ),
            ),
            _buildCard(
              context,
              7,
              'Profil',
              Icons.account_circle,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, int index, String title, IconData icon, VoidCallback onTap) {
    // Her kart için scale değerini başlat
    if (!_scaleValues.containsKey(index)) {
      _scaleValues[index] = 1.0;
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scaleValues[index] = 0.95; // Tıklama anında küçült
        });
      },
      onTapUp: (_) {
        setState(() {
          _scaleValues[index] = 1.0; // Tıklama bırakıldığında normale dön
        });
        onTap(); // Navigasyonu gerçekleştir
      },
      onTapCancel: () {
        setState(() {
          _scaleValues[index] = 1.0; // Tıklama iptal edilirse normale dön
        });
      },
      child: AnimatedScale(
        scale: _scaleValues[index]!,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: const Color(0xFF0052CC)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({required this.url, required this.title});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0052CC),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}