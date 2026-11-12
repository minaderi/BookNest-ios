class KitapModel {
  final String baslik;
  final String yazar;
  final String resimYolu;
  final String aciklama;
  final String tur; // Kitabın türü (ör. 'Classics'), yoksa boş

  const KitapModel({
    required this.baslik,
    required this.yazar,
    required this.resimYolu,
    this.aciklama = '',
    this.tur = '',
  });

  // Hafızaya kaydetmek / geri okumak için
  Map<String, dynamic> toJson() => {
    'baslik': baslik,
    'yazar': yazar,
    'resimYolu': resimYolu,
    'aciklama': aciklama,
    'tur': tur,
  };

  factory KitapModel.fromJson(Map<String, dynamic> json) => KitapModel(
    baslik: json['baslik'] as String,
    yazar: json['yazar'] as String,
    resimYolu: json['resimYolu'] as String,
    aciklama: json['aciklama'] as String? ?? '',
    tur: json['tur'] as String? ?? '',
  );
}

class KitapListesiModel {
  final String baslik;
  final List<KitapModel> kitaplar;

  const KitapListesiModel({required this.baslik, required this.kitaplar});
}
