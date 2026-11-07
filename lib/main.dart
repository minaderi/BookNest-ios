import 'package:flutter/material.dart';

import 'app.dart';
import 'services/favori_yoneticisi.dart';
import 'services/kullanici_deposu.dart';
import 'services/raf_yoneticisi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Açık oturum varsa o kişinin kitaplarını uygulama açılmadan yükle
  final email = await KullaniciDeposu.oturumuGetir();
  await FavoriYoneticisi.instance.kullaniciyaGec(email);
  await RafYoneticisi.instance.kullaniciyaGec(email);

  runApp(const BookNestApp());
}
