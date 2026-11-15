import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/app_shell.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.dock,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const SogameEquipApp());
}

class SogameEquipApp extends StatefulWidget {
  const SogameEquipApp({super.key});

  @override
  State<SogameEquipApp> createState() => _SogameEquipAppState();
}

class _SogameEquipAppState extends State<SogameEquipApp> {
  var _splashFinished = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SOGAME EQUIP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _splashFinished
              ? const AppShell(key: ValueKey('app'))
              : SplashScreen(
                  key: const ValueKey('splash'),
                  onFinished: () => setState(() => _splashFinished = true),
                ),
        ),
      );
}
