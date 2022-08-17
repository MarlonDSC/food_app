class DishIngredientsModel {
  final int? amount;
  final String? emoji;
  final String? name;
  final int? price;
  final bool? primary;
  final bool? topping;
  //If the ingredient adds extra
  final bool? extra;
  int percentage;
  bool avoid;
  bool added;
  //if user selected extra from this ingredient
  bool addedExtra;
  bool isExpanded;

  DishIngredientsModel({
    required this.amount,
    required this.emoji,
    required this.name,
    required this.price,
    required this.primary,
    required this.extra,
    this.percentage = 0,
    this.avoid = false,
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
      extra: snapshot['extra'] ?? true,
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
