import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesController, Set<String>>(
  (ref) => FavoritesController(),
);

class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super({}) { _load(); }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    state = preferences.getStringList('favorite_recipe_ids')?.toSet() ?? {};
  }

  Future<void> toggle(String id) async {
    final updated = {...state};
    if (!updated.add(id)) updated.remove(id);
    state = updated;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('favorite_recipe_ids', updated.toList());
  }
}

final darkModeProvider = StateNotifierProvider<ThemeController, bool>(
  (ref) => ThemeController(),
);

class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(false) { _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('dark_mode') ?? false;
  }
  Future<void> setDark(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }
}

final fontScaleProvider = StateNotifierProvider<FontScaleController, double>(
  (ref) => FontScaleController(),
);

class FontScaleController extends StateNotifier<double> {
  FontScaleController() : super(1) { _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('font_scale') ?? 1;
  }
  Future<void> setScale(double value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_scale', value);
  }
}

final cookingHistoryProvider = StateNotifierProvider<CookingHistoryController, List<String>>(
  (ref) => CookingHistoryController(),
);

class CookingHistoryController extends StateNotifier<List<String>> {
  CookingHistoryController() : super([]) { _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('cooking_history') ?? [];
  }
  Future<void> record(String id) async {
    state = [id, ...state.where((item) => item != id)].take(20).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cooking_history', state);
  }
}

final recentSearchesProvider = StateNotifierProvider<SearchHistoryController, List<String>>(
  (ref) => SearchHistoryController(),
);

class SearchHistoryController extends StateNotifier<List<String>> {
  SearchHistoryController() : super([]) { _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('recent_searches') ?? [];
  }
  Future<void> add(String query) async {
    final value = query.trim();
    if (value.isEmpty) return;
    state = [value, ...state.where((item) => item != value)].take(6).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', state);
  }
  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
  }
}
