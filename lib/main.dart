import 'package:flutter/material.dart';

void main() {
  runApp(const BookNestApp());
}

class KitapModel {
  final String baslik;
  final String yazar;
  final String resimYolu;

  const KitapModel({
    required this.baslik,
    required this.yazar,
    required this.resimYolu,
  });
}

class KitapListesiModel {
  final String baslik;
  final List<KitapModel> kitaplar;

  const KitapListesiModel({required this.baslik, required this.kitaplar});
}

// ----------------------------------------------------
// RAF (SHELF) SİSTEMİ - My Books için
// ----------------------------------------------------
const Color kAnaRenk = Color(0xFF75420e);

enum RafTuru { okumakIstiyorum, suAnOkuyorum, okudum }

extension RafTuruEtiket on RafTuru {
  String get etiket {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return 'Want to Read';
      case RafTuru.suAnOkuyorum:
        return 'Currently Reading';
      case RafTuru.okudum:
        return 'Read';
    }
  }

  String get kisaEtiket {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return 'Want to Read';
      case RafTuru.suAnOkuyorum:
        return 'Reading';
      case RafTuru.okudum:
        return 'Read';
    }
  }

  IconData get ikon {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return Icons.bookmark_add_outlined;
      case RafTuru.suAnOkuyorum:
        return Icons.auto_stories_outlined;
      case RafTuru.okudum:
        return Icons.check_circle_outline;
    }
  }
}

class RafKaydi {
  final KitapModel kitap;
  RafTuru raf;
  int puan; // 0 = puan yok, 1-5
  double ilerleme; // 0.0 - 1.0

  RafKaydi({
    required this.kitap,
    required this.raf,
    this.puan = 0,
    this.ilerleme = 0,
  });
}

// Uygulama boyunca tek bir tane olan raf yöneticisi.
// (Şimdilik sadece bellekte tutuluyor, uygulama kapanınca sıfırlanır.)
class RafYoneticisi extends ChangeNotifier {
  RafYoneticisi._();
  static final RafYoneticisi instance = RafYoneticisi._();

  final Map<String, RafKaydi> _kayitlar = {};

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  RafKaydi? kayit(KitapModel k) => _kayitlar[_anahtar(k)];

  // En son eklenen en üstte
  List<RafKaydi> get hepsi => _kayitlar.values.toList().reversed.toList();

  List<RafKaydi> rafta(RafTuru tur) =>
      hepsi.where((k) => k.raf == tur).toList();

  void rafaEkle(KitapModel k, RafTuru tur) {
    final mevcut = kayit(k);
    if (mevcut != null) {
      mevcut.raf = tur;
      if (tur == RafTuru.okudum) mevcut.ilerleme = 1;
      if (tur == RafTuru.okumakIstiyorum) mevcut.ilerleme = 0;
    } else {
      _kayitlar[_anahtar(k)] = RafKaydi(
        kitap: k,
        raf: tur,
        ilerleme: tur == RafTuru.okudum ? 1 : 0,
      );
    }
    notifyListeners();
  }

  void cikar(KitapModel k) {
    _kayitlar.remove(_anahtar(k));
    notifyListeners();
  }

  void puanVer(KitapModel k, int puan) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.puan = puan;
    notifyListeners();
  }

  void ilerlemeGuncelle(KitapModel k, double deger) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.ilerleme = deger;
    if (deger >= 1) {
      mevcut.raf = RafTuru.okudum;
    }
    notifyListeners();
  }
}

// Kitap kapak resmi (bulunamazsa gri kutu gösterir)
Widget kapakResmi(String yol, {double? genislik, double? yukseklik}) {
  return Image.asset(
    yol,
    width: genislik,
    height: yukseklik,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: genislik,
        height: yukseklik,
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    },
  );
}

// Alttan açılan "rafa ekle" menüsü
void rafSecimiGoster(BuildContext context, KitapModel kitap) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      final yonetici = RafYoneticisi.instance;
      final mevcut = yonetici.kayit(kitap)?.raf;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Text(
                  kitap.baslik,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
                child: Text(
                  kitap.yazar,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const Divider(height: 1),
              for (final raf in RafTuru.values)
                ListTile(
                  leading: Icon(raf.ikon, color: kAnaRenk),
                  title: Text(raf.etiket),
                  trailing: mevcut == raf
                      ? const Icon(Icons.check, color: kAnaRenk)
                      : null,
                  onTap: () {
                    yonetici.rafaEkle(kitap, raf);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to "${raf.etiket}"')),
                    );
                  },
                ),
              if (mevcut != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Remove from My Books',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    yonetici.cikar(kitap);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

// Goodreads tarzı "Want to Read" butonu
class RafButonu extends StatelessWidget {
  final KitapModel kitap;

  const RafButonu({super.key, required this.kitap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RafYoneticisi.instance,
      builder: (context, _) {
        final mevcut = RafYoneticisi.instance.kayit(kitap)?.raf;
        final rafta = mevcut != null;
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => rafSecimiGoster(context, kitap),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: rafta ? Colors.white : kAnaRenk,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAnaRenk),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rafta) ...[
                  const Icon(Icons.check, size: 15, color: kAnaRenk),
                  const SizedBox(width: 4),
                ],
                Text(
                  mevcut?.kisaEtiket ?? 'Want to Read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: rafta ? kAnaRenk : Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: rafta ? kAnaRenk : Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F4EC),
        primaryColor: const Color(0xFF75420e),
      ),
      home: const GoodreadsAnaSayfa(),
    );
  }
}

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

  List<KitapModel> get _aramaSonuclari {
    final sorgu = _aramaMetni.toLowerCase().trim();
    final Map<String, KitapModel> benzersiz = {};
    for (final liste in _anaSayfaListeleri) {
      for (final kitap in liste.kitaplar) {
        if (kitap.baslik.toLowerCase().contains(sorgu) ||
            kitap.yazar.toLowerCase().contains(sorgu)) {
          benzersiz['${kitap.baslik}|${kitap.yazar}'] = kitap;
        }
      }
    }
    return benzersiz.values.toList();
  }
  // ---- ARAMA SONU ----

  final List<KitapListesiModel> _anaSayfaListeleri = [
    KitapListesiModel(
      baslik: 'Booker Prize Shortlist 2026',
      kitaplar: [
        const KitapModel(
          baslik: 'Black Bag',
          yazar: 'Luke Kennard',
          resimYolu: 'assets/images/blackbag.jpg',
        ),
        const KitapModel(
          baslik: 'John of John',
          yazar: 'Douglas Stuart',
          resimYolu: 'assets/images/johnofjohn.jpg',
        ),
        const KitapModel(
          baslik: 'May We Feed the King',
          yazar: 'Rebecca Perry',
          resimYolu: 'assets/images/maywefeedtheking.jpg',
        ),
        const KitapModel(
          baslik: 'The Things We Never Say',
          yazar: 'Elizabeth Strout',
          resimYolu: 'assets/images/strout.jpg',
        ),
        const KitapModel(
          baslik: 'The Disappearers',
          yazar: 'Marlon James',
          resimYolu: 'assets/images/thedisappearers.jpeg',
        ),
        const KitapModel(
          baslik: 'The End of Everything',
          yazar: 'M. John Harrison',
          resimYolu: 'assets/images/theendofeveything.jpg',
        ),
      ],
    ),
    KitapListesiModel(
      baslik: 'Service95 Book Club',
      kitaplar: [
        const KitapModel(
          baslik: 'Lost Lambs',
          yazar: 'Madeline Cash',
          resimYolu: 'assets/images/243808687.jpg',
        ),
        const KitapModel(
          baslik: 'Flesh',
          yazar: 'David Szalay',
          resimYolu: 'assets/images/214152261.jpg',
        ),
        const KitapModel(
          baslik: 'Just Kids',
          yazar: 'Patti Smith',
          resimYolu: 'assets/images/206318521.jpg',
        ),
        const KitapModel(
          baslik: 'Martyr!',
          yazar: 'Kaveh Akbar',
          resimYolu: 'assets/images/139400713.jpg',
        ),
        const KitapModel(
          baslik: 'The Vanishing Half',
          yazar: 'Brit Bennett',
          resimYolu: 'assets/images/51791252.jpg',
        ),
        const KitapModel(
          baslik: 'Pachinko',
          yazar: 'Min Jin Lee',
          resimYolu: 'assets/images/34051011.jpg',
        ),
        const KitapModel(
          baslik: 'A Thousand Splendid Suns',
          yazar: 'Khaled Hosseini',
          resimYolu: 'assets/images/128029.jpg',
        ),
      ],
    ),
    KitapListesiModel(
      baslik: 'Goth Classics',
      kitaplar: [
        const KitapModel(
          baslik: 'Carmilla',
          yazar: 'J. Sheridan Le Fanu',
          resimYolu: 'assets/images/48037.jpg',
        ),
        const KitapModel(
          baslik: 'The Castle of Otranto',
          yazar: 'Horace Walpole',
          resimYolu: 'assets/images/12923.jpg',
        ),
        const KitapModel(
          baslik: 'The Monk',
          yazar: 'Matthew Gregory Lewis',
          resimYolu: 'assets/images/93157.jpg',
        ),
        const KitapModel(
          baslik: 'Frankenstein',
          yazar: 'Mary Shelley',
          resimYolu: 'assets/images/35031085.jpg',
        ),
        const KitapModel(
          baslik: 'Dracula',
          yazar: 'Bram Stoker',
          resimYolu: 'assets/images/17245.jpg',
        ),
        const KitapModel(
          baslik: 'Wuthering Heights',
          yazar: 'Emily Brontë',
          resimYolu: 'assets/images/32929156.jpg',
        ),
        const KitapModel(
          baslik: 'The Old English Baron',
          yazar: 'Clara Reeve',
          resimYolu: 'assets/images/856279.jpg',
        ),
        const KitapModel(
          baslik: 'The Italian',
          yazar: 'Ann Radcliffe',
          resimYolu: 'assets/images/93136.jpg',
        ),
      ],
    ),
  ];

  late final List<Widget> _sayfalar = [
    AnaSayfaIcerigi(listeler: _anaSayfaListeleri),
    const MyBooksPage(),
    const ProfilePage(),
    const SearchPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFF7F4EC),
          elevation: 0,
          title: Container(
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
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.notifications_none, color: Colors.black87),
            ),
          ],
        ),
      ),
      body: _aramaMetni.trim().isNotEmpty
          ? AramaSonuclariSayfasi(
              sonuclar: _aramaSonuclari,
              sorgu: _aramaMetni.trim(),
            )
          : _sayfalar[_seciliSekme],
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
}

// ----------------------------------------------------
// SAYFA WIDGET'LARI
// ----------------------------------------------------

class AnaSayfaIcerigi extends StatelessWidget {
  final List<KitapListesiModel> listeler;

  const AnaSayfaIcerigi({super.key, required this.listeler});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listeler.length,
      itemBuilder: (context, listeIndex) {
        final listeModel = listeler[listeIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    listeModel.baslik,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListeDetaySayfasi(listeModel: listeModel),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: listeModel.kitaplar.length,
                itemBuilder: (context, kitapIndex) {
                  final kitap = listeModel.kitaplar[kitapIndex];
                  return GestureDetector(
                    onTap: () => rafSecimiGoster(context, kitap),
                    child: Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              kitap.resimYolu,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          kitap.baslik,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          kitap.yazar,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  RafTuru? _filtre; // null = hepsi

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RafYoneticisi.instance,
      builder: (context, _) {
        final yonetici = RafYoneticisi.instance;
        final liste =
            _filtre == null ? yonetici.hepsi : yonetici.rafta(_filtre!);

        return Column(
          children: [
            _buildBaslik(yonetici),
            _buildFiltreler(yonetici),
            const Divider(height: 1),
            Expanded(
              child: liste.isEmpty
                  ? _buildBos()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: liste.length,
                      itemBuilder: (context, index) =>
                          _buildKitapKarti(liste[index]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBaslik(RafYoneticisi yonetici) {
    final okunan = yonetici.rafta(RafTuru.okudum).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Books',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '$okunan read',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltreler(RafYoneticisi yonetici) {
    Widget chip(String etiket, int sayi, RafTuru? tur) {
      final secili = _filtre == tur;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text('$etiket ($sayi)'),
          selected: secili,
          showCheckmark: false,
          selectedColor: kAnaRenk,
          backgroundColor: Colors.white,
          side: const BorderSide(color: kAnaRenk),
          labelStyle: TextStyle(
            fontSize: 13,
            color: secili ? Colors.white : kAnaRenk,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) {
            setState(() {
              _filtre = tur;
            });
          },
        ),
      );
    }

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          chip('All', yonetici.hepsi.length, null),
          for (final tur in RafTuru.values)
            chip(tur.etiket, yonetici.rafta(tur).length, tur),
        ],
      ),
    );
  }

  Widget _buildBos() {
    final mesaj = _filtre == null
        ? 'Your shelves are empty'
        : 'No books on "${_filtre!.etiket}" yet';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              mesaj,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap a book on Home or in search results to add it to a shelf.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitapKarti(RafKaydi kayit) {
    final kitap = kayit.kitap;
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: kapakResmi(kitap.resimYolu, genislik: 70, yukseklik: 105),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kitap.baslik,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'by ${kitap.yazar}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _buildYildizlar(kayit),
                if (kayit.raf == RafTuru.suAnOkuyorum) ...[
                  const SizedBox(height: 8),
                  _buildIlerleme(kayit),
                ],
                const SizedBox(height: 10),
                RafButonu(kitap: kitap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYildizlar(RafKaydi kayit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () {
              // Aynı yıldıza tekrar basınca puanı kaldırır
              RafYoneticisi.instance.puanVer(
                kayit.kitap,
                kayit.puan == i ? 0 : i,
              );
            },
            child: Icon(
              i <= kayit.puan ? Icons.star : Icons.star_border,
              size: 24,
              color: i <= kayit.puan ? Colors.amber : Colors.grey,
            ),
          ),
        if (kayit.puan == 0)
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              'Rate this book',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildIlerleme(RafKaydi kayit) {
    final yuzde = (kayit.ilerleme * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: kayit.ilerleme,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            color: kAnaRenk,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '$yuzde% done',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _ilerlemeDialogu(kayit),
              child: const Text(
                'Update progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kAnaRenk,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _ilerlemeDialogu(RafKaydi kayit) {
    double deger = kayit.ilerleme;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update progress'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(deger * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kAnaRenk,
                    ),
                  ),
                  Slider(
                    value: deger,
                    activeColor: kAnaRenk,
                    onChanged: (v) {
                      setDialogState(() {
                        deger = v;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAnaRenk,
                  ),
                  onPressed: () {
                    RafYoneticisi.instance.ilerlemeGuncelle(kayit.kitap, deger);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// PROFİL SAYFASI
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static bool _isLoggedIn = false;
  static String _userEmail = '';
  static String _userName = '';

  // Geçici Yerel Veritabanı (Backend eklenene kadar kullanıcıları burada tutuyoruz)
  // Format: 'email' : {'name': 'Kullanıcı Adı', 'password': 'Sifre'}
  static final Map<String, Map<String, String>> _registeredUsers = {};

  bool _isRegistering = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn ? _buildProfileContent() : _buildAuthCard(),
    );
  }

  Widget _buildProfileContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF75420e),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                _userName.isNotEmpty ? _userName : 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail.isNotEmpty ? _userEmail : 'user@booknest.com',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('12', 'Read'),
              _buildStatItem('5', 'Favorites'),
              _buildStatItem('3', 'Goal'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF75420e),
                ),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF75420e),
                ),
                title: const Text('Account Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _isLoggedIn = false;
                    _userEmail = '';
                    _userName = '';
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRegistering
                  ? Icons.person_add_outlined
                  : Icons.lock_person_outlined,
              size: 70,
              color: const Color(0xFF75420e),
            ),
            const SizedBox(height: 16),
            Text(
              _isRegistering ? 'Create an Account' : 'Sign in to BookNest',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isRegistering
                  ? 'Sign up to start tracking your reading journey.'
                  : 'Log in to see your favorite books and reading list.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            if (_isRegistering) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75420e),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                String email = _emailController.text.trim();
                String password = _passwordController.text;
                String name = _nameController.text.trim();

                // Boş alan kontrolü
                if (email.isEmpty ||
                    password.isEmpty ||
                    (_isRegistering && name.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields!')),
                  );
                  return;
                }

                if (_isRegistering) {
                  // Kayıt Olma İşlemi
                  if (_registeredUsers.containsKey(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This email is already registered. Please log in.',
                        ),
                      ),
                    );
                  } else {
                    _registeredUsers[email] = {
                      'name': name,
                      'password': password,
                    };
                    setState(() {
                      _userEmail = email;
                      _userName = name;
                      _isLoggedIn = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful!')),
                    );
                  }
                } else {
                  // Giriş Yapma İşlemi
                  if (!_registeredUsers.containsKey(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This account is not registered. Please sign up first.',
                        ),
                      ),
                    );
                  } else if (_registeredUsers[email]!['password'] != password) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect password! Please try again.'),
                      ),
                    );
                  } else {
                    setState(() {
                      _userEmail = email;
                      _userName = _registeredUsers[email]!['name']!;
                      _isLoggedIn = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged in successfully!')),
                    );
                  }
                }
              },
              child: Text(
                _isRegistering ? 'Register' : 'Log In',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                  _emailController.clear();
                  _passwordController.clear();
                  _nameController.clear();
                });
              },
              child: Text(
                _isRegistering
                    ? 'Already have an account? Log In'
                    : "Don't have an account? Register",
                style: const TextStyle(color: Color(0xFF75420e)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF75420e),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75420e),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully!'),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'More Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ----------------------------------------------------
// LİSTE DETAY SAYFASI
// ----------------------------------------------------
class ListeDetaySayfasi extends StatelessWidget {
  final KitapListesiModel listeModel;

  const ListeDetaySayfasi({super.key, required this.listeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          listeModel.baslik,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listeModel.kitaplar.length,
        itemBuilder: (context, index) {
          final kitap = listeModel.kitaplar[index];
          return Container(
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
                  child: Image.asset(
                    kitap.resimYolu,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
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
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                RafButonu(kitap: kitap),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ----------------------------------------------------
// ARAMA SONUÇLARI SAYFASI
// ----------------------------------------------------
class AramaSonuclariSayfasi extends StatelessWidget {
  final List<KitapModel> sonuclar;
  final String sorgu;

  const AramaSonuclariSayfasi({
    super.key,
    required this.sonuclar,
    required this.sorgu,
  });

  @override
  Widget build(BuildContext context) {
    if (sonuclar.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$sorgu"',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sonuclar.length,
      itemBuilder: (context, index) {
        final kitap = sonuclar[index];
        return Container(
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
                child: Image.asset(
                  kitap.resimYolu,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
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
        );
      },
    );
  }
}
// test yorumu