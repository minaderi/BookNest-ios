import 'kitap_model.dart';
import 'raf_turu.dart';

class RafKaydi {
  final KitapModel kitap;
  RafTuru raf;
  int puan; // 0 = puan yok, 1-5
  double ilerleme; // 0.0 - 1.0

  RafKaydi({
    required this.kitap,
    required this.raf,
    this.puan = 0,
    this.ilerleme = 0,
  });
}