import 'package:flutter/material.dart';

import 'core/sabitler.dart';
import 'screens/goodreads_ana_sayfa.dart';

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kArkaPlanRengi,
        primaryColor: kAnaRenk,
      ),
      home: const GoodreadsAnaSayfa(),
    );
  }
}