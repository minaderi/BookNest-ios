import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../widgets/kitap_satir_karti.dart';

class ListeDetaySayfasi extends StatelessWidget {
  final KitapListesiModel listeModel;

  const ListeDetaySayfasi({super.key, required this.listeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: AppBar(
        backgroundColor: kArkaPlanRengi,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          listeModel.baslik,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listeModel.kitaplar.length,
        itemBuilder: (context, index) =>
            KitapSatirKarti(kitap: listeModel.kitaplar[index]),
      ),
    );
  }
}