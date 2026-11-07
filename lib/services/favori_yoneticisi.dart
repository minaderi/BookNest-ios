import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kitap_model.dart';

// Uygulama boyunca tek bir tane olan favori yöneticisi.
// Her kullanıcının favorileri cihaz hafızasında ayrı saklanır.
class FavoriYoneticisi extends ChangeNotifier {
  FavoriYoneticisi._();
  static final FavoriYoneticisi instance = FavoriYoneticisi._();

  final Map<String, KitapModel> _favoriler = {};
  String? _email; // giriş yapan kullanıcı (yoksa null)

  bool get girisYapildi => _email != null;

  String _anahtar(KitapModel k) => '${k.baslik}|${k.yazar}';

  bool favoriMi(KitapModel k) => _favoriler.containsKey(_anahtar(k));

  // En son eklenen en üstte
  List<KitapModel> get hepsi => _favoriler.values.toList().reversed.toList();

  int get sayi => _favoriler.length;

  // Giriş yapılınca o kişinin favorilerini yükler, çıkışta (null) boşaltır
  Future<void> kullaniciyaGec(String? email) async {
    _email = email;
    _favoriler.clear();
    if (email != null) {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('favoriler_$email');
      if (_email != email) return; // bu sırada başka kullanıcıya geçildiyse
      if (json != null) {
        for (final kitapJson in jsonDecode(json) as List) {
          final kitap = KitapModel.fromJson(kitapJson as Map<String, dynamic>);
          _favoriler[_anahtar(kitap)] = kitap;
        }
      }
    }
    notifyListeners();
  }

  void degistir(KitapModel k) {
    if (!girisYapildi) return;
    final anahtar = _anahtar(k);
    if (_favoriler.containsKey(anahtar)) {
      _favoriler.remove(anahtar);
    } else {
      _favoriler[anahtar] = k;
    }
    notifyListeners();
    _kaydet();
  }

  Future<void> _kaydet() async {
    final email = _email;
    if (email == null) return;
    final prefs = await SharedPreferences.getInstance();
    final liste = _favoriler.values.map((k) => k.toJson()).toList();
    await prefs.setString('favoriler_$email', jsonEncode(liste));
  }
}
