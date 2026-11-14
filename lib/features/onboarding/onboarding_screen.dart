import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  final _pages = const [
    ('assets/images/recipes/qabili_palaw.jpg', 'کشف طعم‌های فراموش‌نشدنی', 'از غذاهای اصیل افغانی تا محبوب‌ترین دستورهای جهان؛ الهام تازه هر روز در کنار شماست.'),
    ('assets/images/recipes/mantu.jpg', 'آشپزی را با اطمینان بیاموزید', 'روش‌های پخت روشن و مرحله‌به‌مرحله، همراه با زمان‌سنج و اندازه‌های دقیق مواد.'),
    ('assets/images/recipes/bolani.jpg', 'سفر به سفره‌های گوناگون', 'دستورهای سنتی افغانستان و مزه‌های دوست‌داشتنی از گوشه‌وکنار جهان را تجربه کنید.'),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/home');
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _finish,
              child: const Text('رد کردن', style: TextStyle(color: AppTheme.muted)),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) {
                final item = _pages[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                  child: Column(children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(fit: StackFit.expand, children: [
                          Image.asset(item.$1, fit: BoxFit.cover),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(.4)],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 19,
                            right: 20,
                            child: Text('مزه‌ای برای هر لحظه', style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(item.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(item.$3, textAlign: TextAlign.center, style: const TextStyle(height: 1.8, fontSize: 14, color: AppTheme.muted)),
                    const SizedBox(height: 24),
                  ]),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _page == index ? 25 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _page == index ? AppTheme.green : AppTheme.line,
                borderRadius: BorderRadius.circular(8),
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _page == 2
                    ? _finish
                    : () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                ),
                child: Text(_page == 2 ? 'شروع کنید' : 'ادامه', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
