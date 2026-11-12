import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Search sayfasındaki son aramaları cihaz hafızasında saklar.
// En yeni arama en başta durur, en fazla [_enFazla] arama tutulur.
// [liste] değişince onu dinleyen ekranlar kendini yeniler.
class SonAramalarDeposu {
  static const _anahtar = 'son_aramalar';
  static const _enFazla = 8;

  static final ValueNotifier<List<String>> liste = ValueNotifier([]);

  static Future<void> yukle() async {
    final prefs = await SharedPreferences.getInstance();
    liste.value = prefs.getStringList(_anahtar) ?? [];
  }

  static Future<void> ekle(String sorgu) async {
    final temiz = sorgu.trim();
    if (temiz.isEmpty) return;

    // Aynı arama varsa (büyük/küçük harf fark etmez) eskisini çıkarıp başa al
    final yeni = [
      temiz,
      ...liste.value.where((s) => s.toLowerCase() != temiz.toLowerCase()),
    ].take(_enFazla).toList();
    await _kaydet(yeni);
  }

  static Future<void> sil(String sorgu) =>
      _kaydet(liste.value.where((s) => s != sorgu).toList());

  static Future<void> temizle() => _kaydet([]);

  static Future<void> _kaydet(List<String> yeni) async {
    liste.value = yeni;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_anahtar, yeni);
  }
}
