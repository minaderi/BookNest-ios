import 'package:flutter/material.dart';

import '../models/kitap_model.dart';
import '../screens/kitap_detay_sayfasi.dart';
import 'kapak_resmi.dart';
import 'raf_butonu.dart';

// Liste detay ve arama sonuçlarında kullanılan yatay kitap kartı
class KitapSatirKarti extends StatelessWidget {
  final KitapModel kitap;

  const KitapSatirKarti({super.key, required this.kitap});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8),
            RafButonu(kitap: kitap),
          ],
        ),
      ),
    );
  }
}