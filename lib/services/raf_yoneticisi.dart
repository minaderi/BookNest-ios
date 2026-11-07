import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kitap_model.dart';
import '../models/raf_kaydi.dart';
import '../models/raf_turu.dart';

// Uygulama boyunca tek bir tane olan raf yöneticisi.
// Her kullanıcının rafları cihaz hafızasında ayrı saklanır.
class RafYoneticisi extends ChangeNotifier {
  RafYoneticisi._();
  static final RafYoneticisi instance = RafYoneticisi._();

  final Map<String, RafKaydi> _kayitlar = {};
  String? _email; // giriş yapan kullanıcı (yoksa null)
  int _hedef = 0; // yıllık okuma hedefi (0 = belirlenmedi)

  bool get girisYapildi => _email != null;

  int get hedef => _hedef;

  // Giriş yapılınca o kişinin raflarını yükler, çıkışta (null) boşaltır
  Future<void> kullaniciyaGec(String? email) async {
    _email = email;
    _kayitlar.clear();
    _hedef = 0;
    if (email != null) {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('raflar_$email');
      if (_email != email) return; // bu sırada başka kullanıcıya geçildiyse
      _hedef = int.tryParse(prefs.getString('hedef_$email') ?? '') ?? 0;
      if (json != null) {
        for (final kayitJson in jsonDecode(json) as List) {
          final kayit = RafKaydi.fromJson(kayitJson as Map<String, dynamic>);
          _kayitlar[_anahtar(kayit.kitap)] = kayit;
        }
      }
    }
    notifyListeners();
  }

  // Her değişiklikten sonra çağrılır: ekranı günceller ve hafızaya yazar
  void _degisti() {
    notifyListeners();
    _kaydet();
  }

  Future<void> _kaydet() async {
    final email = _email;
    if (email == null) return;
    final prefs = await SharedPreferences.getInstance();
    final liste = _kayitlar.values.map((k) => k.toJson()).toList();
    await prefs.setString('raflar_$email', jsonEncode(liste));
  }

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  RafKaydi? kayit(KitapModel k) => _kayitlar[_anahtar(k)];

  // En son eklenen en üstte
  List<RafKaydi> get hepsi => _kayitlar.values.toList().reversed.toList();

  List<RafKaydi> rafta(RafTuru tur) =>
      hepsi.where((k) => k.raf == tur).toList();

  // Bu yıl okunanlar (tarihi olmayan eski kayıtlar bu yıla sayılır)
  List<RafKaydi> get buYilOkunanlar {
    final yil = DateTime.now().year;
    return rafta(RafTuru.okudum)
        .where((k) => k.bitisTarihi == null || k.bitisTarihi!.year == yil)
        .toList();
  }

  // Yıllık hedefi belirler ve kaydeder
  Future<void> hedefBelirle(int sayi) async {
    final email = _email;
    if (email == null) return;
    _hedef = sayi;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hedef_$email', '$sayi');
  }

  // Rafı değiştirir; "Read" rafına yeni giriyorsa bitirme tarihini yazar
  void _rafiAyarla(RafKaydi kayit, RafTuru tur) {
    if (tur == RafTuru.okudum && kayit.raf != RafTuru.okudum) {
      kayit.bitisTarihi = DateTime.now();
    } else if (tur != RafTuru.okudum) {
      kayit.bitisTarihi = null;
    }
    kayit.raf = tur;
  }

  void rafaEkle(KitapModel k, RafTuru tur) {
    if (!girisYapildi) return;
    final mevcut = kayit(k);
    if (mevcut != null) {
      _rafiAyarla(mevcut, tur);
      if (tur == RafTuru.okudum) mevcut.ilerleme = 1;
      if (tur == RafTuru.okumakIstiyorum) mevcut.ilerleme = 0;
    } else {
      _kayitlar[_anahtar(k)] = RafKaydi(
        kitap: k,
        raf: tur,
        ilerleme: tur == RafTuru.okudum ? 1 : 0,
        bitisTarihi: tur == RafTuru.okudum ? DateTime.now() : null,
      );
    }
    _degisti();
  }

  void cikar(KitapModel k) {
    _kayitlar.remove(_anahtar(k));
    _degisti();
  }

  void puanVer(KitapModel k, int puan) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.puan = puan;
    _degisti();
  }

  void ilerlemeGuncelle(KitapModel k, double deger) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.ilerleme = deger;
    if (deger >= 1) {
      _rafiAyarla(mevcut, RafTuru.okudum);
    }
    _degisti();
  }
}
