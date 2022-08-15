import 'package:food_app/models/avoid_ingredient.dart';

class DishIngredientsModel {
  final int? amount;
  final String? emoji;
  final String? name;
  final int? price;
  final bool? primary;
  final bool? topping;
  int percentage;
  bool ingredientToAvoid;
  bool added;
  bool addedExtra;
  bool isExpanded;

  DishIngredientsModel({
    required this.amount,
    required this.emoji,
    required this.name,
    required this.price,
    required this.primary,
    this.percentage = 0,
    this.ingredientToAvoid = false,
    this.topping = false,
    this.added = true,
    this.addedExtra = false,
    this.isExpanded = false,
  });
  factory DishIngredientsModel.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return DishIngredientsModel(
      amount: snapshot['amount'],
      emoji: snapshot['emoji'],
      name: snapshot['name'],
      price: snapshot['price'],
      primary: snapshot['primary'] ?? false,
      topping: snapshot['topping'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "amount": amount,
      "emoji": emoji,
      "name": name,
      "price": price,
      "primary": primary,
      "topping": topping,
    };
  }
}
