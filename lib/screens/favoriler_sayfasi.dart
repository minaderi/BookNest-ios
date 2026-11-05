import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/favori_yoneticisi.dart';
import '../widgets/favori_butonu.dart';
import '../widgets/kapak_resmi.dart';
import 'kitap_detay_sayfasi.dart';

class FavorilerSayfasi extends StatelessWidget {
  const FavorilerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: AppBar(
        backgroundColor: kArkaPlanRengi,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: FavoriYoneticisi.instance,
        builder: (context, _) {
          final favoriler = FavoriYoneticisi.instance.hepsi;
          if (favoriler.isEmpty) return _buildBos();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriler.length,
            itemBuilder: (context, index) =>
                _buildKitapKarti(context, favoriler[index]),
          );
        },
      ),
    );
  }

  Widget _buildBos() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart on a book to add it to your favorites.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitapKarti(BuildContext context, KitapModel kitap) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KitapDetaySayfasi(kitap: kitap),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: kapakResmi(kitap.resimYolu, genislik: 60, yukseklik: 90),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kitap.baslik,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kitap.yazar,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            FavoriButonu(kitap: kitap),
          ],
        ),
      ),
    );
  }
}