import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/local_recipe_data.dart';
import '../models/recipe.dart';

abstract interface class RecipeRepository {
  List<Recipe> getAll();
  Recipe? findById(String id);
  List<Recipe> findByCategory(String category);
}

/// Local implementation kept behind a repository boundary so a remote source
/// can replace it later without moving data-access logic into the UI.
class LocalRecipeRepository implements RecipeRepository {
  LocalRecipeRepository() : _recipes = List.unmodifiable(localRecipes);

  final List<Recipe> _recipes;

  @override
  List<Recipe> getAll() => _recipes;

  @override
  Recipe? findById(String id) {
    for (final recipe in _recipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  @override
  List<Recipe> findByCategory(String category) =>
      _recipes.where((recipe) => recipe.category == category).toList(growable: false);
}

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) => LocalRecipeRepository());
