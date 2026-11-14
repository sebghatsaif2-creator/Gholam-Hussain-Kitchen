import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../shared/widgets/recipe_card.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;
  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  int servings = 4;

  @override
  Widget build(BuildContext context) {
    final recipe = ref.watch(recipeRepositoryProvider).findById(widget.recipeId) ?? localRecipes.first;
    final isFavorite = ref.watch(favoritesProvider).contains(recipe.id);
    final related = localRecipes.where((item) => item.id != recipe.id && item.cuisine == recipe.cuisine).take(6).toList();
    return Scaffold(body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: SizedBox(height: 340, child: Stack(fit: StackFit.expand, children: [
        Hero(tag: 'recipe-${recipe.id}', child: Image.asset(recipe.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppTheme.green))),
        DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(.42), Colors.transparent, Colors.black.withOpacity(.55)]))),
        SafeArea(child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), child: Row(children: [
          _roundAction(context, Icons.arrow_forward_rounded, () => context.pop()), const Spacer(),
          _roundAction(context, Icons.ios_share_rounded, () async { await Clipboard.setData(ClipboardData(text: '${recipe.name}\n${recipe.description}')); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('مشخصات دستور برای اشتراک‌گذاری کپی شد.'))); }),
          const SizedBox(width: 8),
          _roundAction(context, isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, () => ref.read(favoritesProvider.notifier).toggle(recipe.id), color: isFavorite ? const Color(0xFFC4584F) : AppTheme.ink),
        ])))),
        Positioned(right: 22, bottom: 23, left: 22, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(20)), child: Text(recipe.category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))), const SizedBox(height: 8), Text(recipe.name, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)), const SizedBox(height: 7), Row(children: [const Icon(Icons.star_rounded, size: 18, color: AppTheme.gold), const SizedBox(width: 4), Text(persianDigits(recipe.rating), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), const SizedBox(width: 8), Text('(${persianDigits(128)} نظر)', style: const TextStyle(color: Colors.white70, fontSize: 12))])]))
      ]))),
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 25), sliver: SliverList(delegate: SliverChildListDelegate([
        Text(recipe.description, style: const TextStyle(fontSize: 14, height: 1.8, color: AppTheme.muted)),
        const SizedBox(height: 20),
        Row(children: [Expanded(child: _info(Icons.hourglass_top_rounded, 'آماده‌سازی', '${persianDigits(recipe.preparationMinutes)} دقیقه')), Expanded(child: _info(Icons.local_fire_department_outlined, 'زمان پخت', '${persianDigits(recipe.cookingMinutes)} دقیقه')), Expanded(child: _info(Icons.signal_cellular_alt_rounded, 'دشواری', recipe.difficulty))]),
        const SizedBox(height: 23),
        Row(children: [const Expanded(child: Text('مواد لازم', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19))), IconButton(onPressed: servings > 1 ? () => setState(() => servings--) : null, icon: const Icon(Icons.remove_circle_outline_rounded, color: AppTheme.green)), Text(persianDigits(servings), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), IconButton(onPressed: () => setState(() => servings++), icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.green)), const Text(' نفر', style: TextStyle(color: AppTheme.muted, fontSize: 12))]),
        const SizedBox(height: 8),
        ...recipe.ingredients.map((ingredient) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle)), const SizedBox(width: 11), Expanded(child: Text(ingredient.name, style: const TextStyle(fontSize: 14))), Text(persianDigits(ingredient.quantityFor(servings, recipe.servings)), style: const TextStyle(fontSize: 13, color: AppTheme.green, fontWeight: FontWeight.w700))]))),
        const SizedBox(height: 18),
        Row(children: [const Expanded(child: Text('روش پخت', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19))), Text('${recipe.steps.length} مرحله', style: const TextStyle(color: AppTheme.muted, fontSize: 12))]),
        const SizedBox(height: 10),
        ...List.generate(recipe.steps.length, (index) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 31, height: 31, alignment: Alignment.center, decoration: BoxDecoration(color: AppTheme.green.withOpacity(.10), shape: BoxShape.circle), child: Text(persianDigits(index + 1), style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.w800))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مرحلهٔ ${persianDigits(index + 1)}', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(recipe.steps[index], style: const TextStyle(color: AppTheme.muted, height: 1.75, fontSize: 13))]))]))),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppTheme.green.withOpacity(.08), borderRadius: BorderRadius.circular(18)), child: Row(children: [const Icon(Icons.bolt_rounded, color: AppTheme.gold), const SizedBox(width: 9), Expanded(child: Text('حدود ${persianDigits(recipe.calories)} کیلوکالری در هر وعده', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))])),
        const SizedBox(height: 18),
        SizedBox(height: 54, child: FilledButton.icon(onPressed: () => context.push('/cook/${recipe.id}'), icon: const Icon(Icons.play_arrow_rounded), label: const Text('شروع حالت آشپزی', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), style: FilledButton.styleFrom(backgroundColor: AppTheme.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))))),
        if (related.isNotEmpty) ...[
          const SizedBox(height: 28), const Text('شاید این‌ها را هم بپسندید', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 13),
          SizedBox(height: 255, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: related.length, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (context, index) => RecipeCard(recipe: related[index], compact: true))),
        ],
      ]))),
    ]));
  }

  Widget _info(IconData icon, String label, String value) => Column(children: [Icon(icon, color: AppTheme.green, size: 20), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.muted))]);
  Widget _roundAction(BuildContext context, IconData icon, VoidCallback action, {Color? color}) => Material(color: Colors.white.withOpacity(.94), shape: const CircleBorder(), child: InkWell(customBorder: const CircleBorder(), onTap: action, child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon, size: 20, color: color ?? AppTheme.ink))));
}
