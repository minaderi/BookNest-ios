import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../models/raf_turu.dart';
import '../services/favori_yoneticisi.dart';
import '../services/raf_yoneticisi.dart';

// Alttan açılan "rafa ekle" menüsü
void rafSecimiGoster(BuildContext context, KitapModel kitap) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      final yonetici = RafYoneticisi.instance;
      final mevcut = yonetici.kayit(kitap)?.raf;
      final favori = FavoriYoneticisi.instance.favoriMi(kitap);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Text(
                  kitap.baslik,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
                child: Text(
                  kitap.yazar,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const Divider(height: 1),
              for (final raf in RafTuru.values)
                ListTile(
                  leading: Icon(raf.ikon, color: kAnaRenk),
                  title: Text(raf.etiket),
                  trailing: mevcut == raf
                      ? const Icon(Icons.check, color: kAnaRenk)
                      : null,
                  onTap: () {
                    yonetici.rafaEkle(kitap, raf);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to "${raf.etiket}"')),
                    );
                  },
                ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  favori ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                title: Text(
                  favori ? 'Remove from Favorites' : 'Add to Favorites',
                ),
                onTap: () {
                  FavoriYoneticisi.instance.degistir(kitap);
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        favori ? 'Removed from Favorites' : 'Added to Favorites',
                      ),
                    ),
                  );
                },
              ),
              if (mevcut != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Remove from My Books',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    yonetici.cikar(kitap);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}