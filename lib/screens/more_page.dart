import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../services/favori_yoneticisi.dart';
import '../services/raf_yoneticisi.dart';
import 'admin_paneli_sayfasi.dart';
import 'favoriler_sayfasi.dart';
import 'my_ratings_page.dart';
import 'reading_goal_page.dart';
import 'reading_stats_page.dart';

// Demo için sabit admin şifresi.
// (Gerçek uygulamada bu kontrol sunucuda, kullanıcı rolüyle yapılmalı.)
const String _adminSifresi = 'admin123';

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
        const SizedBox(height: 12),
        // ---- ADMIN PANEL ----
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.admin_panel_settings_outlined,
              color: kAnaRenk,
            ),
            title: const Text('Admin Panel'),
            subtitle: const Text('Manage books and lists'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _adminGirisi(context),
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

  Future<void> _adminGirisi(BuildContext context) async {
    final sonuc = await showDialog<bool>(
      context: context,
      builder: (_) => const _AdminGirisDialog(),
    );
    if (!context.mounted || sonuc == null) return; // iptal edildi

    if (sonuc) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminPaneliSayfasi()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong admin password')),
      );
    }
  }
}

// Admin şifresi soran pencere
class _AdminGirisDialog extends StatefulWidget {
  const _AdminGirisDialog();

  @override
  State<_AdminGirisDialog> createState() => _AdminGirisDialogState();
}

class _AdminGirisDialogState extends State<_AdminGirisDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kontrolEt() {
    Navigator.pop(context, _controller.text == _adminSifresi);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Admin Login'),
      content: TextField(
        controller: _controller,
        obscureText: true,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Admin password'),
        onSubmitted: (_) => _kontrolEt(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
          onPressed: _kontrolEt,
          child: const Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}