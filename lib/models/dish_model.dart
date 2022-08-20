import 'package:food_app/models/dish_ingredients.dart';

class DishModel {
  String id;
  final String? name;
  final String? price;
  final String? description;
  final String? picture;
  final String? type;
  final String? country;
  final List<DishIngredientsModel>? ingredients;
  int amount;
  int totalPrice;

  DishModel({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.picture,
    required this.type,
    required this.country,
    required this.ingredients,
    this.amount = 1,
    this.totalPrice = 0,
  });

  factory DishModel.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return DishModel(
      // ingredientes: snapshot['ingredients'],
      id: snapshot['id'],
      name: snapshot['name'],
      price: snapshot['price'],
      description: snapshot['description'],
      picture: snapshot['picture'],
      type: snapshot['type'],
      country: snapshot['country'],
      ingredients: snapshot['ingredients'] == null
          ? null
          : List<DishIngredientsModel>.from(
              snapshot['ingredients'].map(
                (x) => DishIngredientsModel.fromFirestore(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "picture": picture,
      "type": type,
      "country": country,
      "ingredients": ingredients,
    };
  }
}
