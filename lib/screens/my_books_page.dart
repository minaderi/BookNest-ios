import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/raf_kaydi.dart';
import '../models/raf_turu.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/kapak_resmi.dart';
import '../widgets/raf_butonu.dart';

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
                  style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
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