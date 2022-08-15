class DishIngredientsModel {
  final int? amount;
  final String? emoji;
  final String? name;
  final int? price;
  bool added;
  bool addedExtra;
  bool isExpanded;

  DishIngredientsModel({
    required this.amount,
    required this.emoji,
    required this.name,
    required this.price,
    this.added = false,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "amount": amount,
      "emoji": emoji,
      "name": name,
      "price": price,
    };
  }
}
