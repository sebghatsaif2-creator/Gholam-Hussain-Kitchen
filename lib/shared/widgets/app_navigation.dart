import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _destinations = [
    (Icons.home_rounded, 'خانه'),
    (Icons.search_rounded, 'جستجو'),
    (Icons.favorite_rounded, 'علاقه‌مندی‌ها'),
    (Icons.person_rounded, 'پروفایل'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 72,
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 24, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: List.generate(_destinations.length, (index) {
              final selected = shell.currentIndex == index;
              final destination = _destinations[index];
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => shell.goBranch(index, initialLocation: index == shell.currentIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 230),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.green.withOpacity(.10) : Colors.transparent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(destination.$1, size: 21, color: selected ? AppTheme.green : AppTheme.muted),
                      const SizedBox(height: 3),
                      Text(destination.$2, maxLines: 1, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? AppTheme.green : AppTheme.muted)),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
