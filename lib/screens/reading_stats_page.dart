import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/raf_turu.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/bos_durum.dart';

// OKUMA İSTATİSTİKLERİ SAYFASI
// Raflardaki kitaplardan hesaplanan özet bilgiler.
class ReadingStatsPage extends StatelessWidget {
  const ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: sadeAppBar('Reading Stats'),
      body: ListenableBuilder(
        listenable: RafYoneticisi.instance,
        builder: (context, _) {
          final raflar = RafYoneticisi.instance;
          if (!raflar.girisYapildi) return girisGerekli;

          final hepsi = raflar.hepsi;
          if (hepsi.isEmpty) {
            return const BosDurum(
              ikon: Icons.bar_chart,
              baslik: 'No stats yet',
              aciklama: 'Add books to see your stats.',
            );
          }

          final okunan = raflar.rafta(RafTuru.okudum).length;
          final okunuyor = raflar.rafta(RafTuru.suAnOkuyorum);
          final istenen = raflar.rafta(RafTuru.okumakIstiyorum).length;

          // Ortalama puan (sadece puan verilenler)
          final puanlar = hepsi.where((k) => k.puan > 0).map((k) => k.puan);
          final ortalamaPuan = puanlar.isEmpty
              ? '-'
              : (puanlar.reduce((a, b) => a + b) / puanlar.length)
                    .toStringAsFixed(1);

          // Rafta en çok kitabı olan yazar
          final yazarSayilari = <String, int>{};
          for (final k in hepsi) {
            yazarSayilari[k.kitap.yazar] =
                (yazarSayilari[k.kitap.yazar] ?? 0) + 1;
          }
          final enCok = yazarSayilari.entries.reduce(
            (a, b) => b.value > a.value ? b : a,
          );

          // Şu an okunanların ortalama ilerlemesi
          final ortalamaIlerleme = okunuyor.isEmpty
              ? '-'
              : '${(okunuyor.map((k) => k.ilerleme).reduce((a, b) => a + b) / okunuyor.length * 100).round()}%';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  _sayiKarti('$okunan', 'Read', Icons.check_circle_outline),
                  const SizedBox(width: 12),
                  _sayiKarti(
                    '${okunuyor.length}',
                    'Reading',
                    Icons.auto_stories_outlined,
                  ),
                  const SizedBox(width: 12),
                  _sayiKarti(
                    '$istenen',
                    'Want to Read',
                    Icons.bookmark_add_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _bilgiSatiri(
                Icons.star,
                Colors.amber,
                'Average Rating',
                ortalamaPuan == '-' ? 'No ratings yet' : '⭐ $ortalamaPuan / 5',
              ),
              _bilgiSatiri(
                Icons.person_outline,
                kAnaRenk,
                'Favorite Author',
                enCok.value == 1
                    ? enCok.key
                    : '${enCok.key} (${enCok.value} books)',
              ),
              _bilgiSatiri(
                Icons.trending_up,
                kAnaRenk,
                'Average Progress',
                ortalamaIlerleme == '-'
                    ? 'Not reading anything right now'
                    : '$ortalamaIlerleme on current books',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kutu({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sayiKarti(String sayi, String etiket, IconData ikon) {
    return Expanded(
      child: _kutu(
        child: Column(
          children: [
            Icon(ikon, color: kAnaRenk),
            const SizedBox(height: 8),
            Text(
              sayi,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kAnaRenk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etiket,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiSatiri(IconData ikon, Color renk, String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _kutu(
        child: Row(
          children: [
            Icon(ikon, color: renk, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deger,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
