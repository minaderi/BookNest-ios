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

  const KitapListesiModel({
    required this.baslik,
    required this.kitaplar,
  });
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
              children: const [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Title, author or ISBN',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Spacer(),
                Icon(Icons.camera_alt_outlined, color: Colors.grey),
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
      body: ListView.builder(
        itemCount: _anaSayfaListeleri.length,
        itemBuilder: (context, listeIndex) {
          final listeModel = _anaSayfaListeleri[listeIndex];
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
                    // SAĞDAKI ">" İŞARETINE TIKLANDIĞINDA NAVIGATOR.PUSH İLE DETAY SAYFASINA GEÇIŞ
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeDetaySayfasi(listeModel: listeModel),
                          ),
                        );
                      },
                      child: const Icon(Icons.chevron_right, size: 28, color: Colors.black87),
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
                    return Container(
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
                                      child: Icon(Icons.broken_image, color: Colors.grey),
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
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            kitap.yazar,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
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
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
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
// YENİ EKLENEN LİSTE DETAY SAYFASI (TAM SAYFA GÖRÜNÜM)
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
                // Kitap Kapağı Küçük Resim
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
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Kitap Bilgileri
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
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}