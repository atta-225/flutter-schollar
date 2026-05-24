import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 105,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.jpeg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}