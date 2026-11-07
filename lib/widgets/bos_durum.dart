import 'package:flutter/material.dart';

import '../core/sabitler.dart';

// Liste boşken ya da giriş yapılmamışken ortada gösterilen ikon + mesaj
class BosDurum extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String aciklama;

  const BosDurum({
    super.key,
    required this.ikon,
    required this.baslik,
    required this.aciklama,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              baslik,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              aciklama,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Giriş yapılmamışken gösterilen mesaj
const girisGerekli = BosDurum(
  ikon: Icons.lock_outline,
  baslik: 'Please log in',
  aciklama: 'Log in from the Profile tab to track your reading.',
);

// More sayfasından açılan sayfaların ortak üst çubuğu
AppBar sadeAppBar(String baslik) {
  return AppBar(
    backgroundColor: kArkaPlanRengi,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black87),
    title: Text(
      baslik,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  );
}
