import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/models/recipe.dart';

class CookingModeScreen extends ConsumerStatefulWidget {
  const CookingModeScreen({super.key, required this.recipeId});
  final String recipeId;
  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  int step = 0;
  int seconds = 120;
  Timer? timer;
  bool running = false;
  final Set<int> checkedIngredients = {};

  void _toggleTimer() {
    if (running) {
      timer?.cancel(); setState(() => running = false); return;
    }
    setState(() => running = true);
    timer = Timer.periodic(const Duration(seconds: 1), (clock) {
      if (seconds <= 1) { clock.cancel(); if (mounted) setState(() { seconds = 0; running = false; }); }
      else if (mounted) setState(() => seconds--);
    });
  }
  void _resetTimer() { timer?.cancel(); setState(() { seconds = 120; running = false; }); }
  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final recipe = localRecipes.firstWhere((item) => item.id == widget.recipeId, orElse: () => localRecipes.first);
    final progress = (step + 1) / recipe.steps.length;
    return Scaffold(backgroundColor: const Color(0xFFF8F5EF), appBar: AppBar(backgroundColor: const Color(0xFFF8F5EF), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)), title: const Text('حالت آشپزی', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: () => showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (context) => _ingredientsSheet(recipe)), icon: const Icon(Icons.checklist_rounded))]), body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 5, 24, 20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(recipe.name, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
      const SizedBox(height: 18),
      Row(children: [Text('مرحلهٔ ${persianDigits(step + 1)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), const Spacer(), Text('${persianDigits(step + 1)} از ${persianDigits(recipe.steps.length)}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))]),
      const SizedBox(height: 10), ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: progress, minHeight: 7, backgroundColor: AppTheme.line, color: AppTheme.green)),
      const Spacer(flex: 2),
      Container(width: 72, height: 72, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppTheme.line)), child: Icon(_stepIcon(step), color: AppTheme.green, size: 32)),
      const SizedBox(height: 25),
      Text(recipe.steps[step], textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, height: 1.75, fontWeight: FontWeight.w700)),
      const Spacer(flex: 2),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)), child: Column(children: [const Text('زمان‌سنج آشپزی', style: TextStyle(fontSize: 12, color: AppTheme.muted, fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text('${persianDigits((seconds ~/ 60).toString().padLeft(2, '0'))}:${persianDigits((seconds % 60).toString().padLeft(2, '0'))}', style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w800, letterSpacing: 2, color: AppTheme.green)), const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: _resetTimer, icon: const Icon(Icons.restart_alt_rounded)), const SizedBox(width: 8), FilledButton.icon(onPressed: _toggleTimer, icon: Icon(running ? Icons.pause_rounded : Icons.play_arrow_rounded), label: Text(running ? 'مکث' : 'شروع'), style: FilledButton.styleFrom(backgroundColor: AppTheme.green))])])),
      const Spacer(),
      Row(children: [Expanded(child: OutlinedButton.icon(onPressed: step > 0 ? () => setState(() => step--) : null, icon: const Icon(Icons.arrow_forward_rounded), label: const Text('مرحلهٔ قبل'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 51), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))), const SizedBox(width: 12), Expanded(child: FilledButton.icon(onPressed: () { if (step < recipe.steps.length - 1) setState(() => step++); else { ref.read(cookingHistoryProvider.notifier).record(recipe.id); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('آفرین! دستور با موفقیت کامل شد.'))); context.pop(); } }, icon: const Icon(Icons.arrow_back_rounded), label: Text(step == recipe.steps.length - 1 ? 'پایان پخت' : 'مرحلهٔ بعد'), style: FilledButton.styleFrom(backgroundColor: AppTheme.green, minimumSize: const Size(0, 51), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))))])
    ]))));
  }

  IconData _stepIcon(int step) => [Icons.restaurant_menu_rounded, Icons.local_fire_department_rounded, Icons.soup_kitchen_rounded, Icons.timer_rounded, Icons.done_all_rounded][step % 5];

  Widget _ingredientsSheet(Recipe recipe) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 25),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('چک‌لیست مواد اولیه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...List.generate(recipe.ingredients.length, (index) => CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: checkedIngredients.contains(index),
          activeColor: AppTheme.green,
          title: Text(recipe.ingredients[index].name),
          onChanged: (value) => setState(() {
            if (value == true) {
              checkedIngredients.add(index);
            } else {
              checkedIngredients.remove(index);
            }
          }),
        )),
      ],
    ),
  );
}
