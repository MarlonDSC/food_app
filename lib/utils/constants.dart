import 'package:food_app/models/user_ingredient_model.dart';

import '../models/filter_type.dart';

List<FilterType> filterTypeChipList = [
  FilterType('🌐', "All", false, 'filterType'),
  FilterType('🪄', "Recommended", false, 'filterType'),
  FilterType('❤️', "Liked", false, 'filterType'),
  FilterType('🍝', "Pasta", false, 'filterType'),
  FilterType('🍕', "Pizza", false, 'filterType'),
  FilterType('🍔', "Burger", false, 'filterType'),
];

List<FilterType> specialNutritionChipList = [
  // FilterType('✔️', 'No special nutrition', false, userIngredient: [
  //   UserIngredientModel(
  //     name: '',
  //     percentage: 0,
  //     avoid: true,
  //   ),
  // ]),
  // FilterType('🍺', "alcohol free", false, userIngredient: [
  //   UserIngredientModel(
  //     name: 'gin',
  //     percentage: 100,
  //     avoid: true,
  //   ),
  //   UserIngredientModel(
  //     name: 'vodka',
  //     percentage: 100,
  //     avoid: true,
  //   ),
  //   UserIngredientModel(
  //     name: 'whiskey',
  //     percentage: 100,
  //     avoid: true,
  //   ),
  //   UserIngredientModel(
  //     name: 'whiskey',
  //     percentage: 100,
  //     avoid: true,
  //   ),
  // ]),
  FilterType('🌾', "gluten free", false, 'specialNutrition', userIngredient: [
    UserIngredientModel(
      name: 'wheat',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'rye',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'barley',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'soy sauce',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'malted milk',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'oatmeal',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'bulgur',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'durum',
      percentage: 100,
      avoid: true,
    ),
  ]),
  FilterType('🥛', "lactose free", false, 'specialNutrition', userIngredient: [
    UserIngredientModel(
      name: 'milk',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'cream',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'cheese',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'yoghurt',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'butter',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'ice cream',
      percentage: 100,
      avoid: true,
    ),
  ]),
];

List<FilterType> religiousChipList = [
  FilterType('✔️', 'No restriction', false, 'religion', userIngredient: [
    UserIngredientModel(
      name: '',
      percentage: 0,
      avoid: true,
    ),
  ]),
  FilterType('✝️', "Christianity", false, 'religion', userIngredient: [
    UserIngredientModel(
      name: 'alcohol',
      percentage: 100,
      avoid: true,
    ),
  ]),
  FilterType('☪️', "Islam", false, 'religion', userIngredient: [
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lobster',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'shrimp',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'crab',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'wood lice',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'alcohol',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'cheese',
      percentage: 25,
      avoid: true,
    ),
  ]),
  FilterType('✡️', "Judaism", false, 'religion', userIngredient: [
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'shellfish',
      percentage: 100,
      avoid: true,
    ),
  ]),
  FilterType('🕉️', "Hinduism", false, 'religion', userIngredient: [
    UserIngredientModel(
      name: 'beef',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lard',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'milk',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'onion',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'egg',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'coconut',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'garlic',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'fowl',
      percentage: 50,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'alcohol',
      percentage: 75,
      avoid: true,
    ),
  ]),
];

List<FilterType> dietChipList = [
  FilterType('✔️', 'No restriction', false, 'diet', userIngredient: [
    UserIngredientModel(
      name: '',
      percentage: 0,
      avoid: true,
    ),
  ]),
  FilterType('🍃', "Vegan", false, 'diet', userIngredient: [
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'beef',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'goat',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lamb',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'chicken',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'turkey',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'fish',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'crab',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lobster',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'shrimp',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'wood lice',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'milk',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'cream',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'cheese',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'yoghurt',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'butter',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'ice cream',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'egg',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'honey',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'gelatin',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'alcohol',
      percentage: 50,
      avoid: true,
    ),
  ]),
  FilterType('🥛', "Vegetarian", false, 'diet', userIngredient: [
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'beef',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'goat',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lamb',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'chicken',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'turkey',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'fish',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'crab',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lobster',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'shrimp',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'wood lice',
      percentage: 100,
      avoid: true,
    ),
    // UserIngredientModel(
    //   name: 'milk',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'cream',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'cheese',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'yoghurt',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'butter',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'ice cream',
    //   percentage: 100,
    //   avoid: true,
    // ),
    UserIngredientModel(
      name: 'egg',
      percentage: 50,
      avoid: true,
    ),
    // UserIngredientModel(
    //   name: 'honey',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'gelatin',
    //   percentage: 100,
    //   avoid: true,
    // ),
    // UserIngredientModel(
    //   name: 'alcohol',
    //   percentage: 50,
    //   avoid: true,
    // ),
  ]),
  FilterType('🐟', "Pescatarian", false, 'diet', userIngredient: [
    UserIngredientModel(
      name: 'pork',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'beef',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'goat',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'lamb',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'chicken',
      percentage: 100,
      avoid: true,
    ),
    UserIngredientModel(
      name: 'turkey',
      percentage: 100,
      avoid: true,
    ),
  ]),
  // FilterType('🍎', "Fruitarian", false, userIngredient: []),
];

List<FilterType> cuisineChipList = [
  FilterType('🇺🇸', "American", false, 'cuisine'),
  FilterType('🇲🇽', "Mexican", false, 'cuisine'),
  FilterType('🇹🇭', "Thailand", false, 'cuisine'),
  FilterType('🇬🇷', "Greek", false, 'cuisine'),
  FilterType('🇮🇳', "Indian", false, 'cuisine'),
  FilterType('🇯🇵', "Japanese", false, 'cuisine'),
  FilterType('🇪🇸', "Spanish", false, 'cuisine'),
  FilterType('🇫🇷', "French", false, 'cuisine'),
  FilterType('🇨🇳', "Chinese", false, 'cuisine'),
  FilterType('🇮🇹', "Italy", false, 'cuisine'),
];
