import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/models/recipe.dart';
import '../../shared/widgets/recipe_card.dart';

const _categories = [
  ('غذاهای افغانی', Icons.rice_bowl_rounded), ('غذاهای ایرانی', Icons.dining_rounded),
  ('غذاهای بین‌المللی', Icons.public_rounded), ('غذاهای اصلی', Icons.restaurant_rounded),
  ('صبحانه', Icons.breakfast_dining_rounded), ('ناهار', Icons.lunch_dining_rounded),
  ('شام', Icons.dinner_dining_rounded), ('سوپ', Icons.soup_kitchen_rounded),
  ('سالاد', Icons.eco_rounded), ('دسر', Icons.icecream_rounded),
  ('نوشیدنی', Icons.local_cafe_rounded), ('فست‌فود', Icons.fastfood_rounded),
];

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? selected;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (selected == null && extra is String) selected = extra;
  }

  bool _matches(Recipe recipe) {
    if (selected == null) return true;
    if (selected == 'غذاهای افغانی') return recipe.cuisine == 'افغانی';
    if (selected == 'غذاهای ایرانی') return recipe.cuisine == 'ایرانی';
    if (selected == 'غذاهای بین‌المللی') return recipe.cuisine != 'افغانی' && recipe.cuisine != 'ایرانی';
    if (selected == 'غذاهای اصلی') return !['صبحانه', 'دسر', 'نوشیدنی', 'سالاد'].contains(recipe.category);
    if (selected == 'ناهار' || selected == 'شام') return !['صبحانه', 'دسر', 'نوشیدنی'].contains(recipe.category);
    return recipe.category == selected;
  }

  @override
  Widget build(BuildContext context) {
    final recipes = localRecipes.where(_matches).toList();
    return Scaffold(appBar: AppBar(title: const Text('دسته‌بندی‌ها', style: TextStyle(fontWeight: FontWeight.w800)), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())), body: CustomScrollView(slivers: [
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 18), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, index) {
        final item = _categories[index]; final active = selected == item.$1;
        return InkWell(onTap: () => setState(() => selected = active ? null : item.$1), borderRadius: BorderRadius.circular(20), child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: active ? AppTheme.green : Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? AppTheme.green : Theme.of(context).dividerColor)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(item.$2, color: active ? AppTheme.gold : AppTheme.green, size: 26), Text(item.$1, maxLines: 2, style: TextStyle(fontSize: 12, height: 1.45, fontWeight: FontWeight.w700, color: active ? Colors.white : null))])));
      }, childCount: _categories.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .98))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child: Row(children: [Expanded(child: Text(selected ?? 'دستورهای پیشنهادی', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), Text('${recipes.length} دستور', style: const TextStyle(color: AppTheme.muted, fontSize: 12))]))),
      if (recipes.isEmpty) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(30), child: Center(child: Text('در این دسته هنوز دستوری نداریم.')))),
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 25), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, index) => RecipeCard(recipe: recipes[index]), childCount: recipes.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: .69))),
    ]));
  }
}
