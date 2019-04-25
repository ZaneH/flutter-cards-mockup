import 'package:flutter/material.dart';
import 'cards_page.dart';

void main() => runApp(VisaSwiper());

class VisaSwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visa Swiper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CardsPage(title: 'Cards'),
    );
  }
}
