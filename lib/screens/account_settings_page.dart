import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../services/favori_yoneticisi.dart';
import '../services/kullanici_deposu.dart';
import '../services/raf_yoneticisi.dart';

// HESAP AYARLARI SAYFASI
// Kullanıcı adı / e-posta değiştirme ve hesap silme.
// Değişiklikler doğrudan hafızaya yazılır; profil sayfası dönüşte yeniden okur.
class AccountSettingsPage extends StatefulWidget {
  final String email;
  final Map<String, Map<String, String>> kullanicilar;

  const AccountSettingsPage({
    super.key,
    required this.email,
    required this.kullanicilar,
  });

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late String _email = widget.email;

  Map<String, String> get _kullanici => widget.kullanicilar[_email]!;

  void _mesajGoster(String mesaj) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mesaj)));
  }

  // ------------------- KULLANICI ADI -------------------

  Future<void> _kullaniciAdiDegistir() async {
    final kaydedildi = await showDialog<bool>(
      context: context,
      builder: (_) => _FormDialogu(
        baslik: 'Change Username',
        alanlar: [_Alan('New Username', baslangic: _kullanici['name'] ?? '')],
        butonYazisi: 'Save',
        onKaydet: (degerler) async {
          final yeniAd = degerler[0].trim();
          if (yeniAd.isEmpty) return ['Please fill in all fields'];
          if (yeniAd == _kullanici['name']) {
            return ['New username must be different'];
          }
          _kullanici['name'] = yeniAd;
          await KullaniciDeposu.kullanicilariKaydet(widget.kullanicilar);
          return null;
        },
      ),
    );
    if (kaydedildi == true) {
      setState(() {});
      _mesajGoster('Username updated!');
    }
  }

  // ------------------- E-POSTA -------------------

  Future<void> _emailDegistir() async {
    final kaydedildi = await showDialog<bool>(
      context: context,
      builder: (_) => _FormDialogu(
        baslik: 'Change Email',
        alanlar: const [
          _Alan('New Email'),
          _Alan('Current Password', gizli: true),
        ],
        butonYazisi: 'Save',
        onKaydet: (degerler) async {
          final yeniEmail = degerler[0].trim();
          final sifre = degerler[1];

          String? emailHata;
          if (yeniEmail.isEmpty) {
            emailHata = 'Please fill in all fields';
          } else if (yeniEmail == _email) {
            emailHata = 'New email must be different';
          } else if (widget.kullanicilar.containsKey(yeniEmail)) {
            emailHata = 'This email is already in use';
          }
          String? sifreHata;
          if (sifre.isEmpty) {
            sifreHata = 'Please fill in all fields';
          } else if (sifre != _kullanici['password']) {
            sifreHata = 'Password is incorrect';
          }
          if (emailHata != null || sifreHata != null) {
            return [emailHata, sifreHata];
          }

          // Hesabı ve kitapları yeni e-postaya taşı, oturumu güncelle
          final eskiEmail = _email;
          widget.kullanicilar[yeniEmail] = widget.kullanicilar.remove(
            eskiEmail,
          )!;
          await KullaniciDeposu.kullanicilariKaydet(widget.kullanicilar);
          await KullaniciDeposu.kitaplariTasi(eskiEmail, yeniEmail);
          await KullaniciDeposu.oturumuKaydet(yeniEmail);
          await FavoriYoneticisi.instance.kullaniciyaGec(yeniEmail);
          await RafYoneticisi.instance.kullaniciyaGec(yeniEmail);
          _email = yeniEmail;
          return null;
        },
      ),
    );
    if (kaydedildi == true) {
      setState(() {});
      _mesajGoster('Email updated!');
    }
  }

  // ------------------- HESAP SİLME -------------------

  Future<void> _hesabiSil() async {
    final silindi = await showDialog<bool>(
      context: context,
      builder: (_) => _FormDialogu(
        baslik: 'Delete Account',
        aciklama:
            'Are you sure? Your account, favorites and shelves will be '
            'permanently deleted. This cannot be undone.',
        alanlar: const [_Alan('Current Password', gizli: true)],
        butonYazisi: 'Delete',
        tehlikeli: true,
        onKaydet: (degerler) async {
          final sifre = degerler[0];
          if (sifre.isEmpty) return ['Please fill in all fields'];
          if (sifre != _kullanici['password']) {
            return ['Password is incorrect'];
          }

          widget.kullanicilar.remove(_email);
          await KullaniciDeposu.kullanicilariKaydet(widget.kullanicilar);
          await KullaniciDeposu.kitaplariSil(_email);
          await KullaniciDeposu.oturumuKapat();
          await FavoriYoneticisi.instance.kullaniciyaGec(null);
          await RafYoneticisi.instance.kullaniciyaGec(null);
          return null;
        },
      ),
    );
    if (silindi == true && mounted) {
      _mesajGoster('Your account has been deleted');
      Navigator.pop(context);
    }
  }

  // ------------------- SAYFA -------------------

  @override
  Widget build(BuildContext context) {
    // Hesap silindiyse (sayfa kapanırken) boş göster
    final kullanici = widget.kullanicilar[_email];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: kArkaPlanRengi,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: kullanici == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                          color: kAnaRenk,
                        ),
                        title: const Text('Change Username'),
                        subtitle: Text(kullanici['name'] ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _kullaniciAdiDegistir,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.email_outlined,
                          color: kAnaRenk,
                        ),
                        title: const Text('Change Email'),
                        subtitle: Text(_email),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _emailDegistir,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: _hesabiSil,
                  ),
                ),
              ],
            ),
    );
  }
}

// ------------------- ORTAK FORM PENCERESİ -------------------

// Penceredeki bir yazı kutusu
class _Alan {
  final String etiket;
  final bool gizli;
  final String baslangic;

  const _Alan(this.etiket, {this.gizli = false, this.baslangic = ''});
}

// Kutulardan oluşan pencere. onKaydet hata listesi döndürürse
// (her kutu için bir mesaj veya null) hatalar kutuların altında gösterilir;
// null döndürürse işlem başarılıdır ve pencere true ile kapanır.
class _FormDialogu extends StatefulWidget {
  final String baslik;
  final String? aciklama;
  final List<_Alan> alanlar;
  final String butonYazisi;
  final bool tehlikeli;
  final Future<List<String?>?> Function(List<String> degerler) onKaydet;

  const _FormDialogu({
    required this.baslik,
    this.aciklama,
    required this.alanlar,
    required this.butonYazisi,
    this.tehlikeli = false,
    required this.onKaydet,
  });

  @override
  State<_FormDialogu> createState() => _FormDialoguState();
}

class _FormDialoguState extends State<_FormDialogu> {
  late final List<TextEditingController> _controllerlar = [
    for (final alan in widget.alanlar)
      TextEditingController(text: alan.baslangic),
  ];
  late List<String?> _hatalar = List.filled(widget.alanlar.length, null);
  bool _kaydediliyor = false;

  @override
  void dispose() {
    for (final c in _controllerlar) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _kaydet() async {
    setState(() => _kaydediliyor = true);
    final hatalar = await widget.onKaydet(
      _controllerlar.map((c) => c.text).toList(),
    );
    if (!mounted) return;
    if (hatalar == null) {
      Navigator.pop(context, true);
      return;
    }
    setState(() {
      _hatalar = hatalar;
      _kaydediliyor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final renk = widget.tehlikeli ? Colors.red : kAnaRenk;
    return AlertDialog(
      title: Text(widget.baslik),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.aciklama != null) ...[
              Text(widget.aciklama!),
              const SizedBox(height: 8),
            ],
            for (var i = 0; i < widget.alanlar.length; i++)
              TextField(
                controller: _controllerlar[i],
                obscureText: widget.alanlar[i].gizli,
                autofocus: i == 0,
                decoration: InputDecoration(
                  labelText: widget.alanlar[i].etiket,
                  errorText: _hatalar[i],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _kaydediliyor ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: renk),
          onPressed: _kaydediliyor ? null : _kaydet,
          child: Text(
            widget.butonYazisi,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
