import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/models/recipe.dart';
import '../../shared/widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final featured = localRecipes.firstWhere((recipe) => recipe.isFeatured);
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 15, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.green, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.soup_kitchen_rounded, color: AppTheme.gold, size: 23)),
          const SizedBox(width: 11),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('آشپزخانه غلام حسین', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text('طعم خانه، هنر آشپزی', style: TextStyle(fontSize: 11, color: AppTheme.muted))])),
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('در حال حاضر پیام تازه‌ای ندارید.'))), icon: const Icon(Icons.notifications_none_rounded)),
        ]),
        const SizedBox(height: 23),
        const Text('سلام، آشپز خلاق!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        const Text('امروز چه طعمی را به سفره می‌آوریم؟', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
        const SizedBox(height: 18),
        InkWell(onTap: () => context.go('/search'), borderRadius: BorderRadius.circular(17), child: IgnorePointer(child: TextField(decoration: InputDecoration(hintText: 'نام غذا یا مواد اولیه را جستجو کنید', prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.green), suffixIcon: Icon(Icons.tune_rounded, color: AppTheme.muted), filled: true)))),
        const SizedBox(height: 27),
        _sectionTitle(context, 'دسته‌بندی‌ها', 'همه', onTap: () => context.push('/categories')),
        const SizedBox(height: 14),
        SizedBox(height: 94, child: ListView(scrollDirection: Axis.horizontal, children: const [
          _CategoryShortcut('افغانی', Icons.rice_bowl_rounded, 'غذاهای افغانی'), _CategoryShortcut('ایرانی', Icons.local_dining_rounded, 'غذاهای ایرانی'), _CategoryShortcut('صبحانه', Icons.breakfast_dining_rounded, 'صبحانه'), _CategoryShortcut('دسر', Icons.icecream_rounded, 'دسر'), _CategoryShortcut('نوشیدنی', Icons.local_cafe_rounded, 'نوشیدنی'),
        ])),
        const SizedBox(height: 26),
        _sectionTitle(context, 'پیشنهاد ویژهٔ آشپز', 'دستور پخت', onTap: () => context.push('/recipe/${featured.id}')),
        const SizedBox(height: 13),
        _FeaturedCard(recipe: featured),
        const SizedBox(height: 27),
        _sectionTitle(context, 'محبوب‌ترین دستورها', 'مشاهده همه', onTap: () => context.go('/search')),
        const SizedBox(height: 14),
      ]))),
      SliverToBoxAdapter(child: SizedBox(height: 264, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: localRecipes.where((e) => e.rating >= 4.7).length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => RecipeCard(recipe: localRecipes.where((e) => e.rating >= 4.7).elementAt(index), compact: true)))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 14), child: _sectionTitle(context, 'میراث خوش‌مزهٔ افغانستان', 'همه غذاها', onTap: () => context.push('/categories')))),
      SliverToBoxAdapter(child: SizedBox(height: 264, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: localRecipes.where((e) => e.cuisine == 'افغانی').length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => RecipeCard(recipe: localRecipes.where((e) => e.cuisine == 'افغانی').elementAt(index), compact: true)))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 14), child: _sectionTitle(context, 'تازه برای شما', 'کشف دستورها', onTap: () => context.go('/search')))),
      SliverToBoxAdapter(child: SizedBox(height: 264, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: localRecipes.length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => RecipeCard(recipe: localRecipes[localRecipes.length - 1 - index], compact: true)))),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ]);
  }
}

Widget _sectionTitle(BuildContext context, String title, String action, {required VoidCallback onTap}) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))), TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: AppTheme.green, fontSize: 12, fontWeight: FontWeight.w700)))]);

class _CategoryShortcut extends StatelessWidget {
  const _CategoryShortcut(this.label, this.icon, this.filter);
  final String label; final IconData icon; final String filter;
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => context.push('/categories', extra: filter), child: SizedBox(width: 75, child: Column(children: [Container(width: 55, height: 55, decoration: BoxDecoration(color: AppTheme.green.withOpacity(.09), borderRadius: BorderRadius.circular(19)), child: Icon(icon, color: AppTheme.green, size: 24)), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))])));
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => context.push('/recipe/${recipe.id}'), borderRadius: BorderRadius.circular(24), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: SizedBox(height: 205, width: double.infinity, child: Stack(fit: StackFit.expand, children: [Image.asset(recipe.image, fit: BoxFit.cover), DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(.76)]))), Positioned(right: 18, bottom: 17, left: 18, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(20)), child: const Text('انتخاب سرآشپز', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700))), const SizedBox(height: 8), Text(recipe.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)), const SizedBox(height: 5), Row(children: [const Icon(Icons.schedule_rounded, size: 15, color: Colors.white70), const SizedBox(width: 4), Text('${persianDigits(recipe.totalMinutes)} دقیقه', style: const TextStyle(color: Colors.white70, fontSize: 12)), const SizedBox(width: 15), const Icon(Icons.star_rounded, size: 16, color: AppTheme.gold), Text(persianDigits(recipe.rating), style: const TextStyle(color: Colors.white, fontSize: 12))])]))]))));
}
