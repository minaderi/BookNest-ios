import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../services/favori_yoneticisi.dart';
import 'favoriler_sayfasi.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(
            'More',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListenableBuilder(
            listenable: FavoriYoneticisi.instance,
            builder: (context, _) {
              final sayi = FavoriYoneticisi.instance.sayi;
              return ListTile(
                leading: const Icon(Icons.favorite, color: kAnaRenk),
                title: const Text('My Favorites'),
                subtitle: Text(sayi == 1 ? '1 book' : '$sayi books'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavorilerSayfasi(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}