import 'package:food_app/models/user_ingredient_model.dart';

class FilterType {
  String? emoji;
  String? label;
  String? filterName;
  // Color color;
  bool? isSelected;

  List<UserIngredientModel>? userIngredient;
  // final List userIngredient;
  FilterType(
    this.emoji,
    this.label,
    this.isSelected,
    this.filterName, {
    List<UserIngredientModel>? userIngredient,
  }) : userIngredient = userIngredient;
}

class FilterTypes {
  List<FilterType>? filterType;
  int? index;
  String? current;
  FilterTypes(this.filterType, this.index, this.current);
}
