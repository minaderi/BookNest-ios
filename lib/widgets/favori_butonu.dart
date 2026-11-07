import 'package:flutter/material.dart';

import '../models/kitap_model.dart';
import '../services/favori_yoneticisi.dart';

// Kitabı favorilere ekleyen / çıkaran kalp butonu
class FavoriButonu extends StatelessWidget {
  final KitapModel kitap;

  const FavoriButonu({super.key, required this.kitap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoriYoneticisi.instance,
      builder: (context, _) {
        final favori = FavoriYoneticisi.instance.favoriMi(kitap);
        return IconButton(
          tooltip: favori ? 'Remove from Favorites' : 'Add to Favorites',
          icon: Icon(
            favori ? Icons.favorite : Icons.favorite_border,
            color: favori ? Colors.red : Colors.black54,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (!FavoriYoneticisi.instance.girisYapildi) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please log in to save books')),
              );
              return;
            }
            FavoriYoneticisi.instance.degistir(kitap);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  favori ? 'Removed from Favorites' : 'Added to Favorites',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
