import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../shared/widgets/recipe_card.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});
  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final ids = ref.watch(favoritesProvider);
    final recipes = localRecipes.where((recipe) => ids.contains(recipe.id) && (query.isEmpty || recipe.name.contains(query) || recipe.ingredients.any((item) => item.name.contains(query)))).toList();
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('علاقه‌مندی‌های شما', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text('${ids.length} دستور ذخیره‌شده', style: const TextStyle(color: AppTheme.muted, fontSize: 13)), const SizedBox(height: 17), if (ids.isNotEmpty) TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(hintText: 'جستجو در دستورهای ذخیره‌شده', prefixIcon: Icon(Icons.search_rounded, color: AppTheme.green)))]))),
      if (ids.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: _EmptyFavorites()),
      if (ids.isNotEmpty && recipes.isEmpty) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(35), child: Center(child: Text('موردی با این جستجو پیدا نشد.', style: TextStyle(color: AppTheme.muted))))),
      if (recipes.isNotEmpty) SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, index) => RecipeCard(recipe: recipes[index]), childCount: recipes.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: .69))),
    ]);
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 90, height: 90, decoration: BoxDecoration(color: AppTheme.green.withOpacity(.08), shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, color: AppTheme.green, size: 38)), const SizedBox(height: 20), const Text('هنوز دستوری ذخیره نکرده‌اید', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('با لمس قلب روی هر دستور، آن را برای پخت بعدی نگه دارید.', textAlign: TextAlign.center, style: TextStyle(height: 1.7, color: AppTheme.muted)), const SizedBox(height: 18), const Text('از خانه یک دستور خوش‌مزه پیدا کنید.', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.w600))])));
}
