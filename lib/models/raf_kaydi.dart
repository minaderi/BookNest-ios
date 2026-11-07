import 'kitap_model.dart';
import 'raf_turu.dart';

class RafKaydi {
  final KitapModel kitap;
  RafTuru raf;
  int puan; // 0 = puan yok, 1-5
  double ilerleme; // 0.0 - 1.0
  DateTime? bitisTarihi; // "Read" rafına girdiği an (eski kayıtlarda yok)

  RafKaydi({
    required this.kitap,
    required this.raf,
    this.puan = 0,
    this.ilerleme = 0,
    this.bitisTarihi,
  });

  // Hafızaya kaydetmek / geri okumak için
  Map<String, dynamic> toJson() => {
    'kitap': kitap.toJson(),
    'raf': raf.name,
    'puan': puan,
    'ilerleme': ilerleme,
    'bitisTarihi': bitisTarihi?.toIso8601String(),
  };

  factory RafKaydi.fromJson(Map<String, dynamic> json) => RafKaydi(
    kitap: KitapModel.fromJson(json['kitap'] as Map<String, dynamic>),
    raf: RafTuru.values.byName(json['raf'] as String),
    puan: json['puan'] as int? ?? 0,
    ilerleme: (json['ilerleme'] as num?)?.toDouble() ?? 0,
    bitisTarihi: DateTime.tryParse(json['bitisTarihi'] as String? ?? ''),
  );
}
