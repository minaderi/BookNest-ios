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
}
