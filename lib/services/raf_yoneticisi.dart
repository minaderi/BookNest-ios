import 'package:flutter/foundation.dart';

import '../models/kitap_model.dart';
import '../models/raf_kaydi.dart';
import '../models/raf_turu.dart';

// Uygulama boyunca tek bir tane olan raf yöneticisi.
// (Şimdilik sadece bellekte tutuluyor, uygulama kapanınca sıfırlanır.)
class RafYoneticisi extends ChangeNotifier {
  RafYoneticisi._();
  static final RafYoneticisi instance = RafYoneticisi._();

  final Map<String, RafKaydi> _kayitlar = {};

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  RafKaydi? kayit(KitapModel k) => _kayitlar[_anahtar(k)];

  // En son eklenen en üstte
  List<RafKaydi> get hepsi => _kayitlar.values.toList().reversed.toList();

  List<RafKaydi> rafta(RafTuru tur) =>
      hepsi.where((k) => k.raf == tur).toList();

  void rafaEkle(KitapModel k, RafTuru tur) {
    final mevcut = kayit(k);
    if (mevcut != null) {
      mevcut.raf = tur;
      if (tur == RafTuru.okudum) mevcut.ilerleme = 1;
      if (tur == RafTuru.okumakIstiyorum) mevcut.ilerleme = 0;
    } else {
      _kayitlar[_anahtar(k)] = RafKaydi(
        kitap: k,
        raf: tur,
        ilerleme: tur == RafTuru.okudum ? 1 : 0,
      );
    }
    notifyListeners();
  }

  void cikar(KitapModel k) {
    _kayitlar.remove(_anahtar(k));
    notifyListeners();
  }

  void puanVer(KitapModel k, int puan) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.puan = puan;
    notifyListeners();
  }

  void ilerlemeGuncelle(KitapModel k, double deger) {
    final mevcut = kayit(k);
    if (mevcut == null) return;
    mevcut.ilerleme = deger;
    if (deger >= 1) {
      mevcut.raf = RafTuru.okudum;
    }
    notifyListeners();
  }
}