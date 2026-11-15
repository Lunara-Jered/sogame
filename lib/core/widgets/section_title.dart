import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 6, 2, 18),
        child: Row(
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 30,
                    letterSpacing: .3,
                    color: AppColors.foreground,
                  ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Divider(color: AppColors.line, height: 1)),
          ],
        ),
      );
}
