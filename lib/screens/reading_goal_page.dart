import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/bos_durum.dart';
import '../widgets/kitap_satir_karti.dart';

// OKUMA HEDEFİ SAYFASI
// Yıllık hedef, ilerleme halkası ve bu yıl okunan kitaplar.
class ReadingGoalPage extends StatelessWidget {
  const ReadingGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: sadeAppBar('Reading Goal'),
      body: ListenableBuilder(
        listenable: RafYoneticisi.instance,
        builder: (context, _) {
          final raflar = RafYoneticisi.instance;
          if (!raflar.girisYapildi) return girisGerekli;

          final yil = DateTime.now().year;
          final okunanlar = raflar.buYilOkunanlar;
          final hedef = raflar.hedef;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _hedefKarti(context, yil, okunanlar.length, hedef),
              const SizedBox(height: 24),
              Text(
                'Books read in $yil',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (okunanlar.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No books finished yet this year. '
                    'Mark a book as "Read" to count it.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                for (final kayit in okunanlar)
                  KitapSatirKarti(kitap: kayit.kitap),
            ],
          );
        },
      ),
    );
  }

  Widget _hedefKarti(BuildContext context, int yil, int okunan, int hedef) {
    final oran = hedef == 0 ? 0.0 : (okunan / hedef).clamp(0.0, 1.0);
    final tamamlandi = hedef > 0 && okunan >= hedef;

    String altYazi;
    if (hedef == 0) {
      altYazi = 'Set a goal to start tracking';
    } else if (tamamlandi) {
      altYazi = '🎉 Goal completed!';
    } else {
      final kalan = hedef - okunan;
      altYazi = kalan == 1 ? '1 book to go' : '$kalan books to go';
    }

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          Text(
            '$yil Reading Challenge',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: oran,
                  strokeWidth: 12,
                  backgroundColor: kArkaPlanRengi,
                  color: tamamlandi ? Colors.green : kAnaRenk,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hedef == 0 ? '$okunan' : '$okunan / $hedef',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: kAnaRenk,
                        ),
                      ),
                      Text(
                        hedef == 0 ? 'books read' : '${(oran * 100).round()}%',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            altYazi,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tamamlandi ? Colors.green : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kAnaRenk,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _hedefPenceresi(context, hedef),
            icon: const Icon(Icons.flag_outlined),
            label: Text(hedef == 0 ? 'Set Goal' : 'Change Goal'),
          ),
        ],
      ),
    );
  }

  // Hedef sayısını soran pencere
  Future<void> _hedefPenceresi(BuildContext context, int mevcut) async {
    final sayi = await showDialog<int>(
      context: context,
      builder: (_) => _HedefDialogu(mevcut: mevcut),
    );
    if (sayi != null) await RafYoneticisi.instance.hedefBelirle(sayi);
  }
}

class _HedefDialogu extends StatefulWidget {
  final int mevcut;

  const _HedefDialogu({required this.mevcut});

  @override
  State<_HedefDialogu> createState() => _HedefDialoguState();
}

class _HedefDialoguState extends State<_HedefDialogu> {
  late final _controller = TextEditingController(
    text: widget.mevcut == 0 ? '' : '${widget.mevcut}',
  );
  String? _hata;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kaydet() {
    final sayi = int.tryParse(_controller.text.trim());
    if (sayi == null || sayi < 1 || sayi > 1000) {
      setState(() => _hata = 'Enter a number between 1 and 1000');
      return;
    }
    Navigator.pop(context, sayi);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yearly Reading Goal'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'How many books this year?',
          errorText: _hata,
        ),
        onSubmitted: (_) => _kaydet(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
          onPressed: _kaydet,
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
