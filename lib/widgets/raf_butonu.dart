import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/kitap_model.dart';
import '../models/raf_turu.dart';
import '../services/raf_yoneticisi.dart';
import 'raf_secimi_sheet.dart';

// Goodreads tarzı "Want to Read" butonu
class RafButonu extends StatelessWidget {
  final KitapModel kitap;

  const RafButonu({super.key, required this.kitap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RafYoneticisi.instance,
      builder: (context, _) {
        final mevcut = RafYoneticisi.instance.kayit(kitap)?.raf;
        final rafta = mevcut != null;
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => rafSecimiGoster(context, kitap),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: rafta ? Colors.white : kAnaRenk,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAnaRenk),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rafta) ...[
                  const Icon(Icons.check, size: 15, color: kAnaRenk),
                  const SizedBox(width: 4),
                ],
                Text(
                  mevcut?.kisaEtiket ?? 'Want to Read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: rafta ? kAnaRenk : Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: rafta ? kAnaRenk : Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}