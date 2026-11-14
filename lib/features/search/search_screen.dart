import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/local_recipe_data.dart';
import '../../data/models/recipe.dart';
import '../../shared/widgets/recipe_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _difficulty = 'همه';
  String _cuisine = 'همه';
  int _maxMinutes = 0;
  String _sort = 'پیشنهادی';
  final _popular = const ['قابلی پلو', 'منتو', 'غذای سریع', 'صبحانه'];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  List<Recipe> get _results {
    final query = _controller.text.trim().toLowerCase();
    final values = localRecipes.where((recipe) {
      final matchesText = query.isEmpty || recipe.name.toLowerCase().contains(query) || recipe.description.toLowerCase().contains(query) || recipe.category.toLowerCase().contains(query) || recipe.cuisine.toLowerCase().contains(query) || recipe.ingredients.any((ingredient) => ingredient.name.toLowerCase().contains(query));
      return matchesText && (_difficulty == 'همه' || recipe.difficulty == _difficulty) && (_cuisine == 'همه' || recipe.cuisine == _cuisine) && (_maxMinutes == 0 || recipe.totalMinutes <= _maxMinutes);
    }).toList();
    if (_sort == 'زمان کمتر') values.sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));
    if (_sort == 'بالاترین امتیاز') values.sort((a, b) => b.rating.compareTo(a.rating));
    return values;
  }

  Future<void> _showFilters() async {
    await showModalBottomSheet<void>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (context) => StatefulBuilder(builder: (context, update) => Padding(padding: EdgeInsets.fromLTRB(22, 12, 22, 22 + MediaQuery.of(context).viewInsets.bottom), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.line, borderRadius: BorderRadius.circular(3)))),
      const SizedBox(height: 18), const Text('فیلتر دستورها', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
      const SizedBox(height: 19), const Text('درجهٔ دشواری', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 9), Wrap(spacing: 8, children: ['همه', 'آسان', 'متوسط', 'سخت'].map((v) => ChoiceChip(label: Text(v), selected: _difficulty == v, onSelected: (_) => update(() => _difficulty = v))).toList()),
      const SizedBox(height: 14), const Text('نوع غذا', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 9), Wrap(spacing: 8, children: ['همه', 'افغانی', 'ایرانی', 'بین‌المللی'].map((v) => ChoiceChip(label: Text(v), selected: _cuisine == v, onSelected: (_) => update(() => _cuisine = v))).toList()),
      const SizedBox(height: 14), const Text('حداکثر زمان آماده‌سازی', style: TextStyle(fontWeight: FontWeight.w700)),
      Slider(value: _maxMinutes.toDouble(), min: 0, max: 180, divisions: 6, activeColor: AppTheme.green, label: _maxMinutes == 0 ? 'بدون محدودیت' : '$_maxMinutes دقیقه', onChanged: (v) => update(() => _maxMinutes = v.round())),
      Row(children: [Text(_maxMinutes == 0 ? 'بدون محدودیت' : 'تا $_maxMinutes دقیقه', style: const TextStyle(color: AppTheme.muted)), const Spacer(), TextButton(onPressed: () => update(() { _difficulty = 'همه'; _cuisine = 'همه'; _maxMinutes = 0; }), child: const Text('پاک کردن')), FilledButton(onPressed: () { Navigator.pop(context); setState(() {}); }, style: FilledButton.styleFrom(backgroundColor: AppTheme.green), child: const Text('اعمال فیلتر'))]),
    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentSearchesProvider);
    final results = _results;
    final hasQuery = _controller.text.trim().isNotEmpty;
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('جستجو', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5), const Text('الهام تازه برای غذای بعدی شما', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
        const SizedBox(height: 18),
        TextField(controller: _controller, onChanged: (_) => setState(() {}), onSubmitted: (value) => ref.read(recentSearchesProvider.notifier).add(value), textInputAction: TextInputAction.search, decoration: InputDecoration(hintText: 'نام غذا یا مواد اولیه', prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.green), suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [if (hasQuery) IconButton(onPressed: () { _controller.clear(); setState(() {}); }, icon: const Icon(Icons.close_rounded)), IconButton(onPressed: _showFilters, icon: const Icon(Icons.tune_rounded, color: AppTheme.green))]))),
        const SizedBox(height: 13),
        Row(children: [const Text('مرتب‌سازی:', style: TextStyle(color: AppTheme.muted, fontSize: 12)), const SizedBox(width: 7), DropdownButton<String>(value: _sort, underline: const SizedBox(), isDense: true, items: ['پیشنهادی', 'زمان کمتر', 'بالاترین امتیاز'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => _sort = v ?? 'پیشنهادی')), const Spacer(), if (_difficulty != 'همه' || _cuisine != 'همه' || _maxMinutes != 0) TextButton(onPressed: () => setState(() { _difficulty = 'همه'; _cuisine = 'همه'; _maxMinutes = 0; }), child: const Text('حذف فیلترها', style: TextStyle(fontSize: 11)))]),
      ]))),
      if (!hasQuery) ...[
        if (recent.isNotEmpty) SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 5, 20, 5), child: Row(children: [const Expanded(child: Text('جستجوهای اخیر', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))), TextButton(onPressed: () => ref.read(recentSearchesProvider.notifier).clear(), child: const Text('پاک کردن'))]))),
        if (recent.isNotEmpty) SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Wrap(spacing: 8, children: recent.map((value) => ActionChip(avatar: const Icon(Icons.history_rounded, size: 15), label: Text(value), onPressed: () { _controller.text = value; setState(() {}); })).toList()))),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 22, 20, 10), child: const Text('جستجوهای پرطرفدار', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)))),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Wrap(spacing: 8, children: _popular.map((value) => ActionChip(label: Text(value), onPressed: () { _controller.text = value; ref.read(recentSearchesProvider.notifier).add(value); setState(() {}); })).toList()))),
      ] else SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: Text('${results.length} دستور پیدا شد', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.muted)))),
      if (hasQuery && results.isEmpty) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(35, 45, 35, 30), child: Column(children: [Icon(Icons.search_off_rounded, size: 45, color: AppTheme.muted), SizedBox(height: 12), Text('دستوری پیدا نشد', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('نام غذا یا یکی از مواد اولیه را جستجو کنید.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.muted))]))),
      if (hasQuery && results.isNotEmpty) SliverPadding(padding: const EdgeInsets.fromLTRB(20, 3, 20, 24), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, index) => RecipeCard(recipe: results[index]), childCount: results.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: .69))),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ]);
  }
}
