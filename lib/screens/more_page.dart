import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../services/favori_yoneticisi.dart';
import '../services/raf_yoneticisi.dart';
import 'favoriler_sayfasi.dart';
import 'my_ratings_page.dart';
import 'reading_goal_page.dart';
import 'reading_stats_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(
            'More',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Favoriler veya raflar değişince alt yazılar güncellenir
          child: ListenableBuilder(
            listenable: Listenable.merge([
              FavoriYoneticisi.instance,
              RafYoneticisi.instance,
            ]),
            builder: (context, _) {
              final sayi = FavoriYoneticisi.instance.sayi;
              final raflar = RafYoneticisi.instance;
              final puanSayisi = raflar.hepsi.where((k) => k.puan > 0).length;
              final okunan = raflar.buYilOkunanlar.length;
              final yil = DateTime.now().year;

              return Column(
                children: [
                  _satir(
                    context,
                    ikon: Icons.favorite,
                    baslik: 'My Favorites',
                    altYazi: sayi == 1 ? '1 book' : '$sayi books',
                    sayfa: const FavorilerSayfasi(),
                  ),
                  const Divider(height: 1),
                  _satir(
                    context,
                    ikon: Icons.flag_outlined,
                    baslik: 'Reading Goal',
                    altYazi: raflar.hedef == 0
                        ? 'Set a yearly reading goal'
                        : '$okunan / ${raflar.hedef} books in $yil',
                    sayfa: const ReadingGoalPage(),
                  ),
                  const Divider(height: 1),
                  _satir(
                    context,
                    ikon: Icons.bar_chart,
                    baslik: 'Reading Stats',
                    altYazi: 'Your reading at a glance',
                    sayfa: const ReadingStatsPage(),
                  ),
                  const Divider(height: 1),
                  _satir(
                    context,
                    ikon: Icons.star_outline,
                    baslik: 'My Ratings',
                    altYazi: puanSayisi == 1
                        ? '1 book rated'
                        : '$puanSayisi books rated',
                    sayfa: const MyRatingsPage(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _satir(
    BuildContext context, {
    required IconData ikon,
    required String baslik,
    required String altYazi,
    required Widget sayfa,
  }) {
    return ListTile(
      leading: Icon(ikon, color: kAnaRenk),
      title: Text(baslik),
      subtitle: Text(altYazi),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => sayfa));
      },
    );
  }
}
