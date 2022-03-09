import 'package:flutter/material.dart';
import 'dummy_data.dart';
import 'models/meal.dart';
import 'screens/filters_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/categories_screen.dart';

import 'screens/category_meals_screen.dart';
import 'screens/tabs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Meal> _meals = DUMMY_MEALS;
  final List<Meal> _favoriteMeals = [];
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  void _toggleFavorite(String mealdId) {
    int index = _favoriteMeals.indexWhere((element) => element.id == mealdId);
    if (index >= 0) {
      setState(() => _favoriteMeals.removeAt(index));
    } else {
      setState(
          () => _favoriteMeals.add(DUMMY_MEALS.firstWhere((element) => element.id == mealdId)));
    }
  }

  bool _isMealFavorite(String mealId) => _favoriteMeals.any((element) => element.id == mealId);

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _meals = DUMMY_MEALS.where((element) {
        if (_filters['gluten']! && !element.isGlutenFree) return false;
        if (_filters['lactose']! && !element.isLactoseFree) return false;
        if (_filters['vegetarian']! && !element.isVegetarian) return false;
        if (_filters['vegan']! && !element.isVegan) return false;
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.pink,
              secondary: Colors.amber,
            ),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: const TextStyle(
                  fontSize: 20, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: TabsScreen.routeName,
      routes: {
        TabsScreen.routeName: (ctx) => TabsScreen(favoriteMeals: _favoriteMeals),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(avalibleMeals: _meals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(isMealFavorite: _isMealFavorite, toggleFavorite: _toggleFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(filters: _filters, saveFilters: _setFilters)
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const CategoriesScreen());
      },
    );
  }
}
