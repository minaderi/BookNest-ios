import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/kitap_yoneticisi.dart';
import '../widgets/kapak_resmi.dart';

// Admin panelinden kitap ekleme / düzenleme formu.
// kitapIndex verilirse düzenleme modunda açılır.
class KitapFormuSayfasi extends StatefulWidget {
  final int? listeIndex;
  final int? kitapIndex;

  const KitapFormuSayfasi({super.key, this.listeIndex, this.kitapIndex});

  bool get duzenlemeModu => listeIndex != null && kitapIndex != null;

  @override
  State<KitapFormuSayfasi> createState() => _KitapFormuSayfasiState();
}

class _KitapFormuSayfasiState extends State<KitapFormuSayfasi> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _baslik;
  late final TextEditingController _yazar;
  late final TextEditingController _kapak;
  late final TextEditingController _aciklama;
  late int _seciliListe;
  String _seciliTur = ''; // boş = türü yok

  @override
  void initState() {
    super.initState();
    KitapModel? mevcut;
    if (widget.duzenlemeModu) {
      mevcut = KitapYoneticisi.instance.listeler[widget.listeIndex!]
          .kitaplar[widget.kitapIndex!];
    }
    _baslik = TextEditingController(text: mevcut?.baslik ?? '');
    _yazar = TextEditingController(text: mevcut?.yazar ?? '');
    _kapak = TextEditingController(text: mevcut?.resimYolu ?? '');
    _aciklama = TextEditingController(text: mevcut?.aciklama ?? '');
    _seciliListe = widget.listeIndex ?? 0;
    _seciliTur = mevcut?.tur ?? '';

    // Kapak yolu değiştikçe önizleme güncellensin
    _kapak.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _baslik.dispose();
    _yazar.dispose();
    _kapak.dispose();
    _aciklama.dispose();
    super.dispose();
  }

  void _kaydet() {
    if (!_formKey.currentState!.validate()) return;

    final kitap = KitapModel(
      baslik: _baslik.text.trim(),
      yazar: _yazar.text.trim(),
      resimYolu: _kapak.text.trim(),
      aciklama: _aciklama.text.trim(),
      tur: _seciliTur,
    );

    final yonetici = KitapYoneticisi.instance;
    if (widget.duzenlemeModu) {
      yonetici.kitapGuncelle(
        eskiListeIndex: widget.listeIndex!,
        kitapIndex: widget.kitapIndex!,
        yeniListeIndex: _seciliListe,
        yeniKitap: kitap,
      );
    } else {
      yonetici.kitapEkle(_seciliListe, kitap);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.duzenlemeModu ? 'Book updated' : 'Book added'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: AppBar(
        backgroundColor: kArkaPlanRengi,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.duzenlemeModu ? 'Edit Book' : 'Add Book',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kapakResmi(_kapak.text, genislik: 100, yukseklik: 150),
              ),
            ),
            const SizedBox(height: 20),
            _alan(_baslik, 'Title', zorunlu: true),
            _alan(_yazar, 'Author', zorunlu: true),
            _alan(
              _kapak,
              'Cover (asset path or image URL)',
              ipucu: 'assets/images/... or https://...',
            ),
            _alan(_aciklama, 'Description', satir: 5),
            _turSecici(),
            const SizedBox(height: 16),
            _listeSecici(),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAnaRenk,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _kaydet,
                child: Text(
                  widget.duzenlemeModu ? 'Save Changes' : 'Add Book',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alan(
    TextEditingController controller,
    String etiket, {
    bool zorunlu = false,
    String? ipucu,
    int satir = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: satir,
        decoration: InputDecoration(
          labelText: etiket,
          hintText: ipucu,
          alignLabelWithHint: satir > 1,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: zorunlu
            ? (deger) => (deger == null || deger.trim().isEmpty)
                ? '$etiket is required'
                : null
            : null,
      ),
    );
  }

  Widget _turSecici() {
    // Listede olmayan eski bir tür varsa o da seçenek olarak görünsün
    final turler = [
      ...kKitapTurleri,
      if (_seciliTur.isNotEmpty && !kKitapTurleri.contains(_seciliTur))
        _seciliTur,
    ];
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Genre',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _seciliTur,
          isExpanded: true,
          isDense: true,
          items: [
            const DropdownMenuItem(value: '', child: Text('No genre')),
            for (final tur in turler)
              DropdownMenuItem(value: tur, child: Text(tur)),
          ],
          onChanged: (secim) {
            if (secim != null) setState(() => _seciliTur = secim);
          },
        ),
      ),
    );
  }

  Widget _listeSecici() {
    final listeler = KitapYoneticisi.instance.listeler;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'List',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _seciliListe,
          isExpanded: true,
          isDense: true,
          items: [
            for (int i = 0; i < listeler.length; i++)
              DropdownMenuItem(value: i, child: Text(listeler[i].baslik)),
          ],
          onChanged: (secim) {
            if (secim != null) setState(() => _seciliListe = secim);
          },
        ),
      ),
    );
  }
}
