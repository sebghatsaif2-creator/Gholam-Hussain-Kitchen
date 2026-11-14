import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  late final Animation<double> _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

  @override
  void initState() {
    super.initState();
    _continue();
  }

  Future<void> _continue() async {
    await Future<void>.delayed(const Duration(milliseconds: 2100));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    context.go(prefs.getBool('onboarding_complete') == true ? '/home' : '/onboarding');
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.green,
    body: Center(child: ScaleTransition(scale: _scale, child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withOpacity(.11), shape: BoxShape.circle, border: Border.all(color: AppTheme.gold.withOpacity(.75), width: 1.2)), child: const Icon(Icons.soup_kitchen_rounded, size: 45, color: AppTheme.gold)),
      const SizedBox(height: 25),
      const Text('آشپزخانه غلام حسین', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.4)),
      const SizedBox(height: 7),
      Text('طعم اصیل، با هنر آشپزی', style: TextStyle(color: Colors.white.withOpacity(.74), fontSize: 13)),
      const SizedBox(height: 42),
      SizedBox(width: 25, height: 25, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.gold.withOpacity(.8))),
    ]))),
  );
}
