class UserIngredientModel {
  final String? name;
  int? percentage;
  bool? avoid;
  bool isExpanded;

  UserIngredientModel({
    required this.name,
    required this.percentage,
    required this.avoid,
    this.isExpanded = false,
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
