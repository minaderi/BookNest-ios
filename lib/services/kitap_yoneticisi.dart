import 'package:flutter/foundation.dart';

import '../data/ornek_listeler.dart';
import '../models/kitap_model.dart';
import 'favori_yoneticisi.dart';
import 'raf_yoneticisi.dart';

// Uygulamadaki tüm kitap listelerini tutan yönetici.
// Admin paneli kitap ekleyip düzenleyebilsin diye listeler burada
// değiştirilebilir halde tutuluyor.
// (Şimdilik sadece bellekte, uygulama kapanınca örnek listelere döner.)
class KitapYoneticisi extends ChangeNotifier {
  KitapYoneticisi._()
      : _listeler = anaSayfaListeleri
            .map(
              (l) => KitapListesiModel(
                baslik: l.baslik,
                kitaplar: List.of(l.kitaplar),
              ),
            )
            .toList();

  static final KitapYoneticisi instance = KitapYoneticisi._();

  final List<KitapListesiModel> _listeler;

  List<KitapListesiModel> get listeler => List.unmodifiable(_listeler);

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  // Birden fazla listede olan kitaplar tek sayılır
  List<KitapModel> get tumKitaplar {
    final Map<String, KitapModel> benzersiz = {};
    for (final liste in _listeler) {
      for (final kitap in liste.kitaplar) {
        benzersiz[_anahtar(kitap)] = kitap;
      }
    }
    return benzersiz.values.toList();
  }

  List<KitapModel> ara(String sorgu) {
    final s = sorgu.toLowerCase().trim();
    if (s.isEmpty) return [];
    return tumKitaplar
        .where(
          (k) =>
              k.baslik.toLowerCase().contains(s) ||
              k.yazar.toLowerCase().contains(s),
        )
        .toList();
  }

  // ---------------- KİTAP İŞLEMLERİ ----------------

  void kitapEkle(int listeIndex, KitapModel kitap) {
    _listeler[listeIndex].kitaplar.add(kitap);
    notifyListeners();
  }

  void kitapGuncelle({
    required int eskiListeIndex,
    required int kitapIndex,
    required int yeniListeIndex,
    required KitapModel yeniKitap,
  }) {
    final eskiKitap = _listeler[eskiListeIndex].kitaplar[kitapIndex];
    if (eskiListeIndex == yeniListeIndex) {
      _listeler[eskiListeIndex].kitaplar[kitapIndex] = yeniKitap;
    } else {
      _listeler[eskiListeIndex].kitaplar.removeAt(kitapIndex);
      _listeler[yeniListeIndex].kitaplar.add(yeniKitap);
    }
    // Başlık veya yazar değiştiyse eski kayıt raflarda/favorilerde kalmasın
    if (_anahtar(eskiKitap) != _anahtar(yeniKitap)) {
      _baglantilariTemizle(eskiKitap);
    }
    notifyListeners();
  }

  void kitapSil(int listeIndex, int kitapIndex) {
    final kitap = _listeler[listeIndex].kitaplar.removeAt(kitapIndex);
    _baglantilariTemizle(kitap);
    notifyListeners();
  }

  // Kitap artık hiçbir listede yoksa raflardan ve favorilerden de çıkar
  void _baglantilariTemizle(KitapModel kitap) {
    final halaVar = _listeler.any(
      (l) => l.kitaplar.any((k) => _anahtar(k) == _anahtar(kitap)),
    );
    if (halaVar) return;
    if (RafYoneticisi.instance.kayit(kitap) != null) {
      RafYoneticisi.instance.cikar(kitap);
    }
    if (FavoriYoneticisi.instance.favoriMi(kitap)) {
      FavoriYoneticisi.instance.degistir(kitap);
    }
  }

  // ---------------- LİSTE İŞLEMLERİ ----------------

  void listeEkle(String baslik) {
    _listeler.add(KitapListesiModel(baslik: baslik, kitaplar: []));
    notifyListeners();
  }

  void listeYenidenAdlandir(int listeIndex, String yeniBaslik) {
    final eski = _listeler[listeIndex];
    _listeler[listeIndex] = KitapListesiModel(
      baslik: yeniBaslik,
      kitaplar: eski.kitaplar,
    );
    notifyListeners();
  }

  void listeSil(int listeIndex) {
    final silinen = _listeler.removeAt(listeIndex);
    for (final kitap in silinen.kitaplar) {
      _baglantilariTemizle(kitap);
    }
    notifyListeners();
  }
}