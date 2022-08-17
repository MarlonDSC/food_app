import 'package:food_app/models/user_ingredient_model.dart';

import '../models/filter_type.dart';

List<FilterType> filterTypeChipList = [
  FilterType('🌐', "All", false),
  FilterType('🪄', "Recommended", false),
  FilterType('❤️', "Liked", false),
  FilterType('🍝', "Pasta", false),
  FilterType('🍕', "Pizza", false),
  FilterType('🍔', "Burger", false),
];

List<FilterType> specialNutritionChipList = [
  FilterType('🍺', "alcohol free", false, userIngredient: [
    UserIngredientModel(
      name: 'alcohol',
      percentage: 100,
      avoid: true,
    ),
  ]),
  FilterType('🌾', "gluten free", false),
  FilterType('🥛', "lactose free", false),
];

List<FilterType> religiousChipList = [
  FilterType('✝️', "Christianity", false),
  FilterType('☪️', "Islam", false),
  FilterType('✡️', "Judaism", false),
  FilterType('🕉️', "Hinduism", false),
];

List<FilterType> dietChipList = [
  FilterType('🍃', "Vegan", false),
  FilterType('🥛', "Vegetarian", false),
  FilterType('🐟', "Pescatarian", false),
  FilterType('🍎', "Fruitarian", false),
];

List<FilterType> cuisineChipList = [
  FilterType('🇺🇸', "American", false),
  FilterType('🇲🇽', "Mexican", false),
  FilterType('🇹🇭', "Thailand", false),
  FilterType('🇬🇷', "Greek", false),
  FilterType('🇮🇳', "Indian", false),
  FilterType('🇯🇵', "Japanese", false),
  FilterType('🇪🇸', "Spanish", false),
  FilterType('🇫🇷', "French", false),
  FilterType('🇨🇳', "Chinese", false),
  FilterType('🇮🇹', "Italy", false),
];
