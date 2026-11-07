import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Kayıtlı kullanıcıları ve açık oturumu cihaz hafızasında saklar.
// Uygulama kapanıp açılsa da veriler silinmez.
class KullaniciDeposu {
  static const _kullanicilarAnahtari = 'kayitli_kullanicilar';
  static const _oturumAnahtari = 'oturum_email';

  // Format: 'email' : {'name': 'Kullanıcı Adı', 'password': 'Sifre'}
  static Future<Map<String, Map<String, String>>> kullanicilariGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_kullanicilarAnahtari);
    if (json == null) return {};

    final veri = jsonDecode(json) as Map<String, dynamic>;
    return veri.map(
      (email, bilgi) => MapEntry(email, Map<String, String>.from(bilgi as Map)),
    );
  }

  static Future<void> kullanicilariKaydet(
    Map<String, Map<String, String>> kullanicilar,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kullanicilarAnahtari, jsonEncode(kullanicilar));
  }

  // Giriş yapmış kullanıcının e-postası (yoksa null)
  static Future<String?> oturumuGetir() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_oturumAnahtari);
  }

  static Future<void> oturumuKaydet(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_oturumAnahtari, email);
  }

  static Future<void> oturumuKapat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_oturumAnahtari);
  }

  // Seçilen avatarın numarası (1-8), seçilmediyse null
  static Future<int?> avatariGetir(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return int.tryParse(prefs.getString('avatar_$email') ?? '');
  }

  static Future<void> avatariKaydet(String email, int no) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_$email', '$no');
  }

  // Kişinin favori, raf, okuma hedefi ve avatar kayıtlarının anahtarları
  // (FavoriYoneticisi ve RafYoneticisi de aynı anahtarları kullanır)
  static List<String> _kitapAnahtarlari(String email) => [
    'favoriler_$email',
    'raflar_$email',
    'hedef_$email',
    'avatar_$email',
  ];

  // E-posta değişince favori, raf, hedef ve avatarı yeni e-postaya taşır
  static Future<void> kitaplariTasi(String eskiEmail, String yeniEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final eskiler = _kitapAnahtarlari(eskiEmail);
    final yeniler = _kitapAnahtarlari(yeniEmail);
    for (var i = 0; i < eskiler.length; i++) {
      final veri = prefs.getString(eskiler[i]);
      if (veri != null) await prefs.setString(yeniler[i], veri);
      await prefs.remove(eskiler[i]);
    }
  }

  // Hesap silinince o kişinin favori, raf, hedef ve avatarını siler
  static Future<void> kitaplariSil(String email) async {
    final prefs = await SharedPreferences.getInstance();
    for (final anahtar in _kitapAnahtarlari(email)) {
      await prefs.remove(anahtar);
    }
  }
}
