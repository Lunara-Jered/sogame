import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_icon.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.onHome,
    this.onSearch,
    super.key,
  });

  final VoidCallback onHome;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 4, 2, 16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onHome,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 52,
                    fit: BoxFit.contain,
                    semanticLabel: 'SOGAME EQUIP - Accueil',
                  ),
                ),
              ),
            ),
            if (onSearch != null)
              Material(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onSearch,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const AppIcon('search', size: 20),
                  ),
                ),
              ),
          ],
        ),
      );
}
