import 'package:flutter/material.dart';

import '../models/kitap_model.dart';
import '../widgets/kitap_satir_karti.dart';

class AramaSonuclariSayfasi extends StatelessWidget {
  final List<KitapModel> sonuclar;
  final String sorgu;

  const AramaSonuclariSayfasi({
    super.key,
    required this.sonuclar,
    required this.sorgu,
  });

  @override
  Widget build(BuildContext context) {
    if (sonuclar.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$sorgu"',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sonuclar.length,
      itemBuilder: (context, index) => KitapSatirKarti(kitap: sonuclar[index]),
    );
  }
}