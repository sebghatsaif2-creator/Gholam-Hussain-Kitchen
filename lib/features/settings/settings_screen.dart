import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool notifications = true;
  bool newRecipes = true;
  bool reminders = false;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { notifications = prefs.getBool('notifications') ?? true; newRecipes = prefs.getBool('new_recipes') ?? true; reminders = prefs.getBool('cooking_reminders') ?? false; });
  }
  Future<void> _save(String key, Object value) async { final prefs = await SharedPreferences.getInstance(); if (value is bool) await prefs.setBool(key, value); if (value is double) await prefs.setDouble(key, value); }
  void _about() => showAboutDialog(context: context, applicationName: 'آشپزخانه غلام حسین', applicationVersion: '۱.۰.۰', applicationLegalese: 'ساخته‌شده برای دوست‌داران آشپزی و طعم‌های اصیل.');

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    return Scaffold(appBar: AppBar(title: const Text('تنظیمات', style: TextStyle(fontWeight: FontWeight.w800)), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded))), body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
      _heading('ظاهر برنامه'),
      _panel([SwitchListTile(value: isDark, activeColor: AppTheme.green, secondary: const Icon(Icons.dark_mode_outlined), title: const Text('حالت تاریک'), subtitle: const Text('نمایش آرام‌تر در نور کم'), onChanged: (value) => ref.read(darkModeProvider.notifier).setDark(value)), const Divider(height: 1), ListTile(leading: const Icon(Icons.language_rounded), title: const Text('زبان'), subtitle: const Text('فارسی (دری)'), trailing: const Icon(Icons.chevron_left_rounded), onTap: _language)]),
      const SizedBox(height: 23), _heading('خوانایی'),
      _panel([Padding(padding: const EdgeInsets.fromLTRB(16, 13, 16, 3), child: Row(children: [const Icon(Icons.text_fields_rounded), const SizedBox(width: 13), const Expanded(child: Text('اندازهٔ نوشته')), Text(fontScale < 1.1 ? 'معمولی' : 'درشت', style: const TextStyle(color: AppTheme.muted, fontSize: 12))])), Slider(value: fontScale, min: .9, max: 1.3, divisions: 4, activeColor: AppTheme.green, onChanged: (value) => ref.read(fontScaleProvider.notifier).setScale(value)), Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 13), child: Text('پیش‌نمایش متن فارسی', style: TextStyle(fontSize: 14 * fontScale, color: AppTheme.muted)))]),
      const SizedBox(height: 23), _heading('یادآوری‌ها'),
      _panel([SwitchListTile(value: notifications, activeColor: AppTheme.green, secondary: const Icon(Icons.notifications_none_rounded), title: const Text('اعلان‌ها'), subtitle: const Text('مدیریت اعلان‌های برنامه'), onChanged: (value) { setState(() { notifications = value; if (!value) { newRecipes = false; reminders = false; } }); _save('notifications', value); if (!value) { _save('new_recipes', false); _save('cooking_reminders', false); } }), const Divider(height: 1), SwitchListTile(value: newRecipes, activeColor: AppTheme.green, secondary: const Icon(Icons.auto_awesome_outlined), title: const Text('دستورهای تازه'), onChanged: notifications ? (value) { setState(() => newRecipes = value); _save('new_recipes', value); } : null), const Divider(height: 1), SwitchListTile(value: reminders, activeColor: AppTheme.green, secondary: const Icon(Icons.alarm_outlined), title: const Text('یادآوری آشپزی'), onChanged: notifications ? (value) { setState(() => reminders = value); _save('cooking_reminders', value); } : null)]),
      const SizedBox(height: 23), _heading('درباره'),
      _panel([ListTile(leading: const Icon(Icons.info_outline_rounded), title: const Text('دربارهٔ برنامه'), trailing: const Icon(Icons.chevron_left_rounded), onTap: _about), const Divider(height: 1), const ListTile(leading: Icon(Icons.verified_outlined), title: Text('نسخهٔ برنامه'), trailing: Text('۱.۰.۰', style: TextStyle(color: AppTheme.muted)))]),
      const SizedBox(height: 20), const Center(child: Text('آشپزخانه غلام حسین  •  برای طعم‌های ماندگار', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppTheme.muted))),
    ]));
  }

  Widget _heading(String title) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)));
  Widget _panel(List<Widget> children) => Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)), child: Column(children: children));
  void _language() => showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (context) => Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 25), child: Column(mainAxisSize: MainAxisSize.min, children: [const Align(alignment: Alignment.centerRight, child: Text('زبان برنامه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), ListTile(leading: const Icon(Icons.check_circle, color: AppTheme.green), title: const Text('فارسی (دری)'), onTap: () => Navigator.pop(context)), ListTile(leading: const Icon(Icons.language), title: const Text('English'), subtitle: const Text('در نسخهٔ آینده در دسترس خواهد بود'), onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('زبان انگلیسی به‌زودی افزوده می‌شود.'))); })])));
}
