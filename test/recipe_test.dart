import 'package:flutter_test/flutter_test.dart';
import 'package:gholam_hussain_kitchen/data/datasources/local_recipe_data.dart';

void main() {
  group('Local recipe catalogue', () {
    test('includes at least thirty uniquely identified recipes', () {
      expect(localRecipes.length, greaterThanOrEqualTo(30));
      expect(localRecipes.map((recipe) => recipe.id).toSet().length, localRecipes.length);
    });

    test('every recipe has the data required to render a useful detail page', () {
      for (final recipe in localRecipes) {
        expect(recipe.name, isNotEmpty);
        expect(recipe.description, isNotEmpty);
        expect(recipe.image, isNotEmpty);
        expect(recipe.steps, isNotEmpty);
        expect(recipe.ingredients, isNotEmpty);
        expect(recipe.totalMinutes, greaterThan(0));
      }
    });

    test('scales measured ingredient quantities to the selected serving count', () {
      final rice = localRecipes.firstWhere((recipe) => recipe.id == 'qabili').ingredients.first;
      expect(rice.quantityFor(2, 4), '1 پیمانه');
      expect(rice.quantityFor(6, 4), '3 پیمانه');
    });

    test('contains core Afghan classics', () {
      final names = localRecipes.map((recipe) => recipe.name).toSet();
      expect(names, containsAll(['قابلی پلو', 'منتو', 'آشک', 'بولانی', 'کچری قروت', 'شوله', 'چلو کباب', 'شوربا', 'قورمه سبزی', 'کباب افغانی']));
    });
  });
}
