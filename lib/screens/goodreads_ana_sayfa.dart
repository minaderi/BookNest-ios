import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/kitap_yoneticisi.dart';
import 'ana_sayfa_icerigi.dart';
import 'arama_sonuclari_sayfasi.dart';
import 'more_page.dart';
import 'my_books_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class GoodreadsAnaSayfa extends StatefulWidget {
  const GoodreadsAnaSayfa({super.key});

  @override
  State<GoodreadsAnaSayfa> createState() => _GoodreadsAnaSayfaState();
}

class _GoodreadsAnaSayfaState extends State<GoodreadsAnaSayfa> {
  int _seciliSekme = 0;

  // ---- ARAMA ----
  final TextEditingController _aramaController = TextEditingController();
  String _aramaMetni = '';

  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  // Arama artık admin panelindeki güncel kitaplar arasında yapılıyor
  List<KitapModel> get _aramaSonuclari =>
      KitapYoneticisi.instance.ara(_aramaMetni);
  // ---- ARAMA SONU ----

  // Seçili sekmeye göre sayfa
  Widget _seciliSayfa() {
    switch (_seciliSekme) {
      case 0:
        return AnaSayfaIcerigi(listeler: KitapYoneticisi.instance.listeler);
      case 1:
        return const MyBooksPage();
      case 2:
        return const ProfilePage();
      case 3:
        return const SearchPage();
      default:
        return const MorePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: kArkaPlanRengi,
          elevation: 0,
          title: _buildAramaKutusu(),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.notifications_none, color: Colors.black87),
            ),
          ],
        ),
      ),
      // Admin panelinde kitap/liste değişince sayfa kendini yeniler
      body: ListenableBuilder(
        listenable: KitapYoneticisi.instance,
        builder: (context, _) {
          return _aramaMetni.trim().isNotEmpty
              ? AramaSonuclariSayfasi(
                  sonuclar: _aramaSonuclari,
                  sorgu: _aramaMetni.trim(),
                )
              : _seciliSayfa();
        },
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _seciliSekme,
        onDestinationSelected: (index) {
          setState(() {
            _seciliSekme = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'My Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildAramaKutusu() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _aramaController,
              onChanged: (deger) {
                setState(() {
                  _aramaMetni = deger;
                });
              },
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Title, author or ISBN',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_aramaMetni.isNotEmpty)
            GestureDetector(
              onTap: () {
                _aramaController.clear();
                setState(() {
                  _aramaMetni = '';
                });
                FocusScope.of(context).unfocus();
              },
              child: const Icon(Icons.close, color: Colors.grey),
            )
          else
            const Icon(Icons.camera_alt_outlined, color: Colors.grey),
        ],
      ),
    );
  }
}