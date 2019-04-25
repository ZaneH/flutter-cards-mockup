import 'package:flutter/material.dart';

class CCard {
  final String accentImagePath;
  final String last4Digits;
  final String cardProviderLogoPath;
  final Color backgroundColor;
  final String balance;

  CCard({
    this.accentImagePath,
    this.last4Digits,
    this.cardProviderLogoPath,
    this.backgroundColor,
    this.balance = '\$0.00',
  });
}
