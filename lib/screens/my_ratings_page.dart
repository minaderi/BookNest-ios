import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/raf_kaydi.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/bos_durum.dart';
import '../widgets/kapak_resmi.dart';
import 'kitap_detay_sayfasi.dart';

// PUANLADIKLARIM SAYFASI
// Puan verilen kitaplar, en yüksek puandan düşüğe.
class MyRatingsPage extends StatelessWidget {
  const MyRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: sadeAppBar('My Ratings'),
      body: ListenableBuilder(
        listenable: RafYoneticisi.instance,
        builder: (context, _) {
          final raflar = RafYoneticisi.instance;
          if (!raflar.girisYapildi) return girisGerekli;

          final puanlilar = raflar.hepsi.where((k) => k.puan > 0).toList()
            ..sort((a, b) => b.puan.compareTo(a.puan));

          if (puanlilar.isEmpty) {
            return const BosDurum(
              ikon: Icons.star_border,
              baslik: 'No ratings yet',
              aciklama: 'Rate books in My Books to see them here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: puanlilar.length,
            itemBuilder: (context, i) => _kitapKarti(context, puanlilar[i]),
          );
        },
      ),
    );
  }

  Widget _kitapKarti(BuildContext context, RafKaydi kayit) {
    final kitap = kayit.kitap;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KitapDetaySayfasi(kitap: kitap)),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        Icon(
                          i <= kayit.puan ? Icons.star : Icons.star_border,
                          size: 20,
                          color: i <= kayit.puan ? Colors.amber : Colors.grey,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
