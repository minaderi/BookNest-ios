import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/kitap_yoneticisi.dart';
import '../services/son_aramalar_deposu.dart';
import '../widgets/kapak_resmi.dart';
import '../widgets/kitap_satir_karti.dart';
import 'kitap_detay_sayfasi.dart';

// Search sekmesi (arama kutusu üstteki ortak çubukta):
// - Kutu boşken: son aramalar + tüm kitap kapaklarından oluşan ızgara
// - Yazınca: anlık arama sonuçları
class SearchPage extends StatefulWidget {
  // Üst çubuktaki arama kutusunun controller'ı
  final TextEditingController controller;

  const SearchPage({super.key, required this.controller});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String get _sorgu => widget.controller.text;

  @override
  void initState() {
    super.initState();
    SonAramalarDeposu.yukle();
    widget.controller.addListener(_yenile);
  }

  @override
  void didUpdateWidget(SearchPage eski) {
    super.didUpdateWidget(eski);
    if (eski.controller != widget.controller) {
      eski.controller.removeListener(_yenile);
      widget.controller.addListener(_yenile);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_yenile);
    super.dispose();
  }

  void _yenile() => setState(() {});

  void _aramayiKaydet() => SonAramalarDeposu.ekle(_sorgu);

  void _sorguyuAyarla(String deger) {
    widget.controller.value = TextEditingValue(
      text: deger,
      selection: TextSelection.collapsed(offset: deger.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Admin panelinde kitap/liste değişince veya son aramalar değişince
    // sayfa kendini yeniler
    return ListenableBuilder(
      listenable: Listenable.merge([
        KitapYoneticisi.instance,
        SonAramalarDeposu.liste,
      ]),
      builder: (context, _) =>
          _sorgu.trim().isEmpty ? _bosDurum() : _sonuclar(),
    );
  }

  // ---------------- SONUÇLAR ----------------

  Widget _sonuclar() {
    final sonuclar = KitapYoneticisi.instance.ara(_sorgu);

    if (sonuclar.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No results found for "${_sorgu.trim()}"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Try a different title, author, or genre.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: sonuclar.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${sonuclar.length} result${sonuclar.length == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          );
        }
        return KitapSatirKarti(
          kitap: sonuclar[index - 1],
          onTap: _aramayiKaydet,
        );
      },
    );
  }

  // ---------------- BOŞ DURUM ----------------

  Widget _bosDurum() {
    final kitaplar = KitapYoneticisi.instance.tumKitaplar;
    final sonAramalar = SonAramalarDeposu.liste.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        if (sonAramalar.isNotEmpty) ...[
          Row(
            children: [
              const Expanded(child: _BolumBasligi('Recent searches')),
              TextButton(
                onPressed: SonAramalarDeposu.temizle,
                style: TextButton.styleFrom(foregroundColor: kAnaRenk),
                child: const Text('Clear all'),
              ),
            ],
          ),
          ...sonAramalar.map(
            (s) => ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.history, color: Colors.grey),
              title: Text(s, style: const TextStyle(fontSize: 15)),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => SonAramalarDeposu.sil(s),
              ),
              onTap: () {
                _sorguyuAyarla(s);
                _aramayiKaydet();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        const _BolumBasligi('Discover books'),
        const SizedBox(height: 12),
        if (kitaplar.isEmpty)
          const Text('No books yet.', style: TextStyle(color: Colors.grey))
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kitaplar.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) =>
                _KapakKarti(kitap: kitaplar[index]),
          ),
      ],
    );
  }
}

class _BolumBasligi extends StatelessWidget {
  final String metin;

  const _BolumBasligi(this.metin);

  @override
  Widget build(BuildContext context) {
    return Text(
      metin,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

// "Discover books" ızgarasındaki tek bir kapak
class _KapakKarti extends StatelessWidget {
  final KitapModel kitap;

  const _KapakKarti({required this.kitap});

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: kapakResmi(
            kitap.resimYolu,
            genislik: double.infinity,
            yukseklik: double.infinity,
          ),
        ),
      ),
    );
  }
}
