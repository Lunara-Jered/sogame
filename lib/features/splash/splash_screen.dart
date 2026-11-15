import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: Tween<double>(begin: .7, end: 1).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: .97, end: 1).animate(
                    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    fit: BoxFit.contain,
                    semanticLabel: 'SOGAME EQUIP',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CHARGEMENT',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: _dots,
                builder: (context, child) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final phase = (_dots.value - index / 3) % 1;
                    final raised = phase < .5 ? phase * 2 : (1 - phase) * 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Transform.translate(
                        offset: Offset(0, -3 * raised),
                        child: Opacity(
                          opacity: .2 + .8 * raised,
                          child: const CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.yellow,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
}
