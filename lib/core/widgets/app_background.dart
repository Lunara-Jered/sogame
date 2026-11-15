import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background/chargement.png',
            fit: BoxFit.cover,
          ),
          child,
        ],
      );
}
