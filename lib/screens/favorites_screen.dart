import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meals_item.dart';

class FavoritiesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;
  const FavoritiesScreen({Key? key, required this.favoriteMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteMeals.isEmpty) {
      return const Center(child: Text('You have no favorites yet - start adding one'));
    }
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final meal = favoriteMeals[index];
        return MealItem(
          id: meal.id,
          title: meal.title,
          imageUrl: meal.imageUrl,
          duration: meal.duration,
          complexity: meal.complexity,
          affordability: meal.affordability,
        );
      },
      itemCount: favoriteMeals.length,
    );
  }
}
