import 'package:food_app/models/dish_ingredients.dart';
import 'package:food_app/models/nutritional_facts_model.dart';

class DishModel {
  String id;
  final String? name;
  final String? price;
  final String? description;
  final String? picture;
  final String? type;
  final String? country;
  final List<DishIngredientsModel>? ingredients;
  final NutritionalFactsModel? nutritionalFacts;
  int amount;
  int totalPrice;
  double points;

  DishModel({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.picture,
    required this.type,
    required this.country,
    required this.ingredients,
    required this.nutritionalFacts,
    this.amount = 1,
    this.totalPrice = 0,
    this.points = 0,
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
      nutritionalFacts: NutritionalFactsModel(
        calories: snapshot['nutritionalFacts']['calories'],
        fat: snapshot['nutritionalFacts']['fat'],
        saturatedFat: snapshot['nutritionalFacts']['saturatedFat'],
        transFat: snapshot['nutritionalFacts']['transFat'],
        cholesterol: snapshot['nutritionalFacts']['cholesterol'],
        sodium: snapshot['nutritionalFacts']['sodium'],
        carbohydrates: snapshot['nutritionalFacts']['carbohydrates'],
        fiber: snapshot['nutritionalFacts']['fiber'],
        sugar: snapshot['nutritionalFacts']['sugar'],
        proteins: snapshot['nutritionalFacts']['proteins'],
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
      "nutritionalFacts": nutritionalFacts,
    };
  }
}
