import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../services/favori_yoneticisi.dart';
import '../services/kitap_yoneticisi.dart';
import '../services/raf_yoneticisi.dart';
import '../widgets/kapak_resmi.dart';
import 'kitap_formu_sayfasi.dart';

class AdminPaneliSayfasi extends StatelessWidget {
  const AdminPaneliSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final yonetici = KitapYoneticisi.instance;
    return Scaffold(
      backgroundColor: kArkaPlanRengi,
      appBar: AppBar(
        backgroundColor: kArkaPlanRengi,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'New list',
            icon: const Icon(Icons.playlist_add, color: Colors.black87),
            onPressed: () => _listeAdiDialogu(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kAnaRenk,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
        onPressed: () => _kitapFormunuAc(context),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          yonetici,
          RafYoneticisi.instance,
          FavoriYoneticisi.instance,
        ]),
        builder: (context, _) {
          final listeler = yonetici.listeler;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              _buildIstatistikler(),
              const SizedBox(height: 24),
              const Text(
                'Lists & Books',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              if (listeler.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No lists yet. Tap the list icon at the top to create one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              for (int i = 0; i < listeler.length; i++)
                _buildListeKarti(context, i, listeler[i]),
            ],
          );
        },
      ),
    );
  }

  // ---------------- İSTATİSTİKLER ----------------

  Widget _buildIstatistikler() {
    final yonetici = KitapYoneticisi.instance;
    return Row(
      children: [
        _istatistikKarti(
          Icons.menu_book,
          '${yonetici.tumKitaplar.length}',
          'Books',
        ),
        _istatistikKarti(
          Icons.list_alt,
          '${yonetici.listeler.length}',
          'Lists',
        ),
        _istatistikKarti(
          Icons.bookmark,
          '${RafYoneticisi.instance.hepsi.length}',
          'Shelved',
        ),
        _istatistikKarti(
          Icons.favorite,
          '${FavoriYoneticisi.instance.sayi}',
          'Favorites',
        ),
      ],
    );
  }

  Widget _istatistikKarti(IconData ikon, String sayi, String etiket) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(ikon, color: kAnaRenk, size: 22),
            const SizedBox(height: 6),
            Text(
              sayi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              etiket,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LİSTE VE KİTAPLAR ----------------

  Widget _buildListeKarti(
    BuildContext context,
    int listeIndex,
    KitapListesiModel liste,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          liste.baslik,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          liste.kitaplar.length == 1
              ? '1 book'
              : '${liste.kitaplar.length} books',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (secim) {
            if (secim == 'ekle') {
              _kitapFormunuAc(context, listeIndex: listeIndex);
            } else if (secim == 'adlandir') {
              _listeAdiDialogu(context, listeIndex: listeIndex);
            } else if (secim == 'sil') {
              _onayDialogu(
                context,
                baslik: 'Delete list?',
                mesaj:
                    '"${liste.baslik}" and all of its books will be removed.',
                onayla: () => KitapYoneticisi.instance.listeSil(listeIndex),
              );
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'ekle', child: Text('Add book to this list')),
            PopupMenuItem(value: 'adlandir', child: Text('Rename list')),
            PopupMenuItem(
              value: 'sil',
              child: Text('Delete list', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        children: [
          if (liste.kitaplar.isEmpty)
            const ListTile(
              title: Text(
                'No books in this list.',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          for (int k = 0; k < liste.kitaplar.length; k++)
            _buildKitapSatiri(context, listeIndex, k, liste.kitaplar[k]),
        ],
      ),
    );
  }

  Widget _buildKitapSatiri(
    BuildContext context,
    int listeIndex,
    int kitapIndex,
    KitapModel kitap,
  ) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: kapakResmi(kitap.resimYolu, genislik: 36, yukseklik: 54),
      ),
      title: Text(kitap.baslik, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(kitap.yazar, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined, color: kAnaRenk),
            onPressed: () => _kitapFormunuAc(
              context,
              listeIndex: listeIndex,
              kitapIndex: kitapIndex,
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _onayDialogu(
              context,
              baslik: 'Delete book?',
              mesaj: '"${kitap.baslik}" will be removed from this list.',
              onayla: () => KitapYoneticisi.instance.kitapSil(
                listeIndex,
                kitapIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- YARDIMCI İŞLEMLER ----------------

  void _kitapFormunuAc(
    BuildContext context, {
    int? listeIndex,
    int? kitapIndex,
  }) {
    if (KitapYoneticisi.instance.listeler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a list first.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KitapFormuSayfasi(
          listeIndex: listeIndex,
          kitapIndex: kitapIndex,
        ),
      ),
    );
  }

  Future<void> _onayDialogu(
    BuildContext context, {
    required String baslik,
    required String mesaj,
    required VoidCallback onayla,
  }) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(baslik),
        content: Text(mesaj),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (onay == true) onayla();
  }

  Future<void> _listeAdiDialogu(BuildContext context, {int? listeIndex}) async {
    final yonetici = KitapYoneticisi.instance;
    final mevcutAd =
        listeIndex == null ? '' : yonetici.listeler[listeIndex].baslik;

    final yeniAd = await showDialog<String>(
      context: context,
      builder: (_) =>
          _ListeAdiDialog(baslangic: mevcutAd, yeni: listeIndex == null),
    );
    if (yeniAd == null || yeniAd.trim().isEmpty) return;

    if (listeIndex == null) {
      yonetici.listeEkle(yeniAd.trim());
    } else {
      yonetici.listeYenidenAdlandir(listeIndex, yeniAd.trim());
    }
  }
}

// Liste oluşturma / yeniden adlandırma penceresi
class _ListeAdiDialog extends StatefulWidget {
  final String baslangic;
  final bool yeni;

  const _ListeAdiDialog({required this.baslangic, required this.yeni});

  @override
  State<_ListeAdiDialog> createState() => _ListeAdiDialogState();
}

class _ListeAdiDialogState extends State<_ListeAdiDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.baslangic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.yeni ? 'New List' : 'Rename List'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'List name'),
        onSubmitted: (_) => Navigator.pop(context, _controller.text),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}