class UserIngredientModel {
  final String? name;
  final int? percentage;
  final bool? avoid;

  UserIngredientModel({
    required this.name,
    required this.percentage,
    required this.avoid,
  });

  factory UserIngredientModel.fromFirestore(
    Map<String, dynamic> snapshot,
  ) {
    return UserIngredientModel(
      name: snapshot['name'],
      percentage: snapshot['percentage'],
      avoid: snapshot['avoid'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "percentage": percentage,
      "avoid": avoid,
    };
  }
}
