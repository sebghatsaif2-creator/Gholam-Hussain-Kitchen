import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/models/recipe.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String name = 'آشپز خانه';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => name = prefs.getString('profile_name') ?? name);
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: name);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ویرایش نام'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'نام شما')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('ذخیره')),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', value);
      if (mounted) setState(() => name = value);
    }
  }

  void _info(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message, style: const TextStyle(height: 1.7)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(favoritesProvider);
    final history = ref.watch(cookingHistoryProvider);
    final recent = history
        .map((id) => localRecipes.firstWhere((recipe) => recipe.id == id, orElse: () => localRecipes.first))
        .take(4)
        .toList();
    final historyContent = recent.isEmpty
        ? const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('دستورهایی که کامل می‌پزید اینجا نمایش داده می‌شوند.', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
            ),
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: recent.map((Recipe recipe) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(recipe.image, width: 52, height: 52, fit: BoxFit.cover),
                  ),
                  title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(recipe.category, style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => context.push('/recipe/${recipe.id}'),
                )).toList(),
              ),
            ),
          );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 14),
            child: const Text('پروفایل من', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppTheme.green, borderRadius: BorderRadius.circular(25)),
              child: Row(children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.14), shape: BoxShape.circle, border: Border.all(color: AppTheme.gold)),
                  child: const Icon(Icons.person_rounded, color: AppTheme.gold, size: 33),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('عضو خانوادهٔ آشپزخانه', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                ),
                IconButton(onPressed: _editName, icon: const Icon(Icons.edit_outlined, color: Colors.white70)),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 17, 20, 17),
            child: Row(children: [
              _stat('${favoriteIds.length}', 'دستور ذخیره‌شده', Icons.favorite_border_rounded),
              const SizedBox(width: 12),
              _stat('${history.length}', 'تجربهٔ پخت', Icons.restaurant_menu_rounded),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
            child: const Text('فعالیت آشپزی', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
        ),
        historyContent,
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: const Text('تنظیمات و اطلاعات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 25),
            child: Column(children: [
              _action(context, Icons.tune_rounded, 'تنظیمات برنامه', 'زبان، پوسته و نمایش', () => context.push('/settings')),
              _action(context, Icons.language_rounded, 'زبان برنامه', 'فارسی (دری)', () => _languageSheet(context)),
              _action(
                context,
                Icons.dark_mode_outlined,
                'نمایش',
                ref.watch(darkModeProvider) ? 'حالت تاریک' : 'حالت روشن',
                () => ref.read(darkModeProvider.notifier).setDark(!ref.read(darkModeProvider)),
              ),
              _action(context, Icons.info_outline_rounded, 'دربارهٔ برنامه', 'آشپزی با الهام از خانه', () => _info('دربارهٔ آشپزخانه غلام حسین', 'مجموعه‌ای از دستورهای اصیل، آموزش‌های روشن و الهام‌های خوش‌مزه برای سفرهٔ هر روز شما.')),
              _action(context, Icons.shield_outlined, 'حریم خصوصی', 'اطلاعات شما روی همین دستگاه می‌ماند', () => _info('حریم خصوصی', 'علاقه‌مندی‌ها، جستجوها و تنظیمات شما به‌صورت محلی روی دستگاه نگهداری می‌شوند. این نسخه به هیچ سرویس بیرونی متصل نیست.')),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _stat(String number, String label, IconData icon) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            Icon(icon, color: AppTheme.green),
            const SizedBox(width: 9),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(number, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 10)),
            ]),
          ]),
        ),
      );

  Widget _action(BuildContext context, IconData icon, String title, String sub, VoidCallback action) => ListTile(
        onTap: action,
        leading: Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(color: AppTheme.green.withOpacity(.08), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppTheme.green, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Text(sub, style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
        trailing: const Icon(Icons.chevron_left_rounded, color: AppTheme.muted),
      );

  void _languageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(alignment: Alignment.centerRight, child: Text('زبان برنامه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.check_circle, color: AppTheme.green),
            title: const Text('فارسی (دری)'),
            subtitle: const Text('زبان فعلی'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: const Text('English'),
            subtitle: const Text('در نسخهٔ آینده در دسترس خواهد بود'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('زبان انگلیسی به‌زودی افزوده می‌شود.')));
            },
          ),
        ]),
      ),
    );
  }
}
