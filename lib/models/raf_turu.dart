import 'package:flutter/material.dart';

enum RafTuru { okumakIstiyorum, suAnOkuyorum, okudum }

extension RafTuruEtiket on RafTuru {
  String get etiket {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return 'Want to Read';
      case RafTuru.suAnOkuyorum:
        return 'Currently Reading';
      case RafTuru.okudum:
        return 'Read';
    }
  }

  String get kisaEtiket {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return 'Want to Read';
      case RafTuru.suAnOkuyorum:
        return 'Reading';
      case RafTuru.okudum:
        return 'Read';
    }
  }

  IconData get ikon {
    switch (this) {
      case RafTuru.okumakIstiyorum:
        return Icons.bookmark_add_outlined;
      case RafTuru.suAnOkuyorum:
        return Icons.auto_stories_outlined;
      case RafTuru.okudum:
        return Icons.check_circle_outline;
    }
  }
}