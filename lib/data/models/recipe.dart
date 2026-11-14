class Ingredient {
  const Ingredient({required this.name, required this.amount, required this.unit});

  final String name;
  final double amount;
  final String unit;

  String quantityFor(int servings, int baseServings) {
    final value = amount * servings / baseServings;
    final formatted = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return '$formatted $unit';
  }
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.difficulty,
    required this.rating,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.cuisine,
    this.calories = 420,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final int preparationMinutes;
  final int cookingMinutes;
  final String difficulty;
  final double rating;
  final int servings;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final String cuisine;
  final int calories;
  final bool isFeatured;

  int get totalMinutes => preparationMinutes + cookingMinutes;
}
