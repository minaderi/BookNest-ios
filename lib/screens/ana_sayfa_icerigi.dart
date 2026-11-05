import 'package:flutter/material.dart';

import '../models/kitap_model.dart';
import '../widgets/kapak_resmi.dart';
import '../widgets/raf_secimi_sheet.dart';
import 'liste_detay_sayfasi.dart';

class AnaSayfaIcerigi extends StatelessWidget {
  final List<KitapListesiModel> listeler;

  const AnaSayfaIcerigi({super.key, required this.listeler});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listeler.length,
      itemBuilder: (context, listeIndex) {
        final listeModel = listeler[listeIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListeBasligi(context, listeModel),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: listeModel.kitaplar.length,
                itemBuilder: (context, kitapIndex) => _buildKitapKapagi(
                  context,
                  listeModel.kitaplar[kitapIndex],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListeBasligi(BuildContext context, KitapListesiModel listeModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            listeModel.baslik,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ListeDetaySayfasi(listeModel: listeModel),
                ),
              );
            },
            child: const Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitapKapagi(BuildContext context, KitapModel kitap) {
    return GestureDetector(
      onTap: () => rafSecimiGoster(context, kitap),
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: kapakResmi(kitap.resimYolu, genislik: double.infinity),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              kitap.baslik,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              kitap.yazar,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}