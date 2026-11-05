import 'package:flutter/material.dart';

// Kitap kapak resmi (bulunamazsa gri kutu gösterir)
Widget kapakResmi(String yol, {double? genislik, double? yukseklik}) {
  return Image.asset(
    yol,
    width: genislik,
    height: yukseklik,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: genislik,
        height: yukseklik,
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    },
  );
}