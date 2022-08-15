class AvoidIngredientModel {
  final String? name;
  final int? percentage;

  AvoidIngredientModel({
    required this.name,
    required this.percentage,
  });

  factory AvoidIngredientModel.fromFirestore(
    Map<String, dynamic> snapshot,
  ) {
    return AvoidIngredientModel(
      name: snapshot['name'],
      percentage: snapshot['percentage'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "percentage": percentage,
    };
  }
}
