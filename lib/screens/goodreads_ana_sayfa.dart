import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/kitap_yoneticisi.dart';
import '../services/son_aramalar_deposu.dart';
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
  void initState() {
    super.initState();
    // Metin Search sayfasından da değişebiliyor (ör. son aramaya tıklanınca)
    _aramaController.addListener(() {
      if (_aramaController.text != _aramaMetni) {
        setState(() => _aramaMetni = _aramaController.text);
      }
    });
  }

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
        return SearchPage(controller: _aramaController);
      default:
        return const MorePage();
    }
  }

  // Üstteki arama çubuğu sadece My Books (1) ve Search (3) sekmelerinde
  bool get _myBooksSekmesinde => _seciliSekme == 1;
  bool get _searchSekmesinde => _seciliSekme == 3;
  bool get _aramaCubuguVar => _myBooksSekmesinde || _searchSekmesinde;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_aramaCubuguVar
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: kArkaPlanRengi,
                elevation: 0,
                title: _buildAramaKutusu(),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
      // Admin panelinde kitap/liste değişince sayfa kendini yeniler
      body: ListenableBuilder(
        listenable: KitapYoneticisi.instance,
        builder: (context, _) {
          // Search sekmesi sonuçları kendisi gösterir
          return _aramaMetni.trim().isNotEmpty && _myBooksSekmesinde
              ? AramaSonuclariSayfasi(
                  sonuclar: _aramaSonuclari,
                  sorgu: _aramaMetni.trim(),
                )
              // Üst çubuk yoksa içerik saat/pil satırının altından başlasın
              : SafeArea(
                  top: !_aramaCubuguVar,
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: _aramaCubuguVar ? 0 : 8),
                    child: _seciliSayfa(),
                  ),
                );
        },
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _seciliSekme,
        onDestinationSelected: (index) {
          if (index != _seciliSekme) {
            // Sekme değişince yarım kalan arama temizlensin
            _aramaController.clear();
            FocusScope.of(context).unfocus();
          }
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
              textInputAction: TextInputAction.search,
              onSubmitted: (deger) {
                if (_searchSekmesinde) SonAramalarDeposu.ekle(deger);
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
