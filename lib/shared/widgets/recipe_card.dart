import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian.dart';
import '../../data/models/recipe.dart';

class RecipeCard extends ConsumerWidget {
  const RecipeCard({super.key, required this.recipe, this.compact = false});
  final Recipe recipe;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final favorite = favorites.contains(recipe.id);
    return SizedBox(
      width: compact ? 174 : null,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/recipe/${recipe.id}'),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Hero(
                tag: 'recipe-${recipe.id}',
                child: Image.asset(recipe.image, height: compact ? 138 : 180, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback()),
              ),
              Positioned(top: 10, left: 10, child: InkWell(
                onTap: () => ref.read(favoritesProvider.notifier).toggle(recipe.id),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(.94), shape: BoxShape.circle), child: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: favorite ? const Color(0xFFC4584F) : AppTheme.ink, size: 19)),
              )),
              Positioned(bottom: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(.94), borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.star_rounded, color: AppTheme.gold, size: 15), const SizedBox(width: 3), Text(persianDigits(recipe.rating.toStringAsFixed(1)), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]))),
            ]),
            Padding(padding: const EdgeInsets.fromLTRB(13, 11, 13, 13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              Row(children: [Icon(Icons.schedule_rounded, size: 14, color: AppTheme.muted), const SizedBox(width: 4), Text('${persianDigits(recipe.totalMinutes)} دقیقه', style: const TextStyle(fontSize: 11, color: AppTheme.muted)), const Spacer(), Text(recipe.difficulty, style: const TextStyle(fontSize: 11, color: AppTheme.muted))]),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _fallback() => Container(height: compact ? 138 : 180, color: AppTheme.green.withOpacity(.15), child: const Center(child: Icon(Icons.restaurant, color: AppTheme.green, size: 36)));
}
