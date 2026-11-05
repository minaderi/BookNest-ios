import 'package:flutter/foundation.dart';

import '../models/kitap_model.dart';

// Uygulama boyunca tek bir tane olan favori yöneticisi.
// (Şimdilik sadece bellekte tutuluyor, uygulama kapanınca sıfırlanır.)
class FavoriYoneticisi extends ChangeNotifier {
  FavoriYoneticisi._();
  static final FavoriYoneticisi instance = FavoriYoneticisi._();

  final Map<String, KitapModel> _favoriler = {};

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  bool favoriMi(KitapModel k) => _favoriler.containsKey(_anahtar(k));

  // En son eklenen en üstte
  List<KitapModel> get hepsi => _favoriler.values.toList().reversed.toList();

  int get sayi => _favoriler.length;

  void degistir(KitapModel k) {
    final anahtar = _anahtar(k);
    if (_favoriler.containsKey(anahtar)) {
      _favoriler.remove(anahtar);
    } else {
      _favoriler[anahtar] = k;
    }
    notifyListeners();
  }
}