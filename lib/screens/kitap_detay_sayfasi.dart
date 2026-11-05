import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../models/raf_turu.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/favori_butonu.dart';
import '../widgets/kapak_resmi.dart';
import '../widgets/raf_secimi_sheet.dart';

class KitapDetaySayfasi extends StatelessWidget {
  final KitapModel kitap;

  const KitapDetaySayfasi({super.key, required this.kitap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: AppBar(
        backgroundColor: kArkaPlanRengi,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [FavoriButonu(kitap: kitap)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kapakResmi(
                  kitap.resimYolu,
                  genislik: 160,
                  yukseklik: 240,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              kitap.baslik,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              kitap.yazar,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.brown,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star_half, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  '4.25 · 3,421 ratings',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildRafButonu(context),
            const SizedBox(height: 24),
            _buildAciklama(),
          ],
        ),
      ),
    );
  }

  // "About this book" kutusu - kitabın kendi açıklamasını gösterir
  Widget _buildAciklama() {
    final aciklamaVar = kitap.aciklama.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this book',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aciklamaVar ? kitap.aciklama : 'No description available yet.',
            style: TextStyle(
              fontSize: 14,
              color: aciklamaVar ? Colors.black54 : Colors.grey,
              fontStyle: aciklamaVar ? FontStyle.normal : FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Büyük "Want to Read" butonu - raf sistemine bağlı
  Widget _buildRafButonu(BuildContext context) {
    return ListenableBuilder(
      listenable: RafYoneticisi.instance,
      builder: (context, _) {
        final mevcut = RafYoneticisi.instance.kayit(kitap)?.raf;
        final rafta = mevcut != null;
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: rafta ? Colors.white : kAnaRenk,
              foregroundColor: rafta ? kAnaRenk : Colors.white,
              side: const BorderSide(color: kAnaRenk),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () => rafSecimiGoster(context, kitap),
            icon: Icon(rafta ? Icons.check : Icons.bookmark_add),
            label: Text(
              mevcut?.etiket ?? 'Want to Read',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}