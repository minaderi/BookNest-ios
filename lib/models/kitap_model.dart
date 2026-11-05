class KitapModel {
  final String baslik;
  final String yazar;
  final String resimYolu;
  final String aciklama;

  const KitapModel({
    required this.baslik,
    required this.yazar,
    required this.resimYolu,
    this.aciklama = '',
  });
}

class KitapListesiModel {
  final String baslik;
  final List<KitapModel> kitaplar;

  const KitapListesiModel({required this.baslik, required this.kitaplar});
}