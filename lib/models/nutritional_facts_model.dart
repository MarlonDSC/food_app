class NutritionalFactsModel {
  // String id;
  final double? calories;
  final double? fat;
  final double? saturatedFat;
  final double? transFat;
  final double? cholesterol;
  final double? carbohydrates;
  final double? sodium;
  final double? fiber;
  final double? sugar;
  final double? proteins;
  // final int? calories;
  // final int? fat;
  // final int? saturatedFat;
  // final int? transFat;
  // final int? cholesterol;
  // final int? carbohydrates;
  // final int? sodium;
  // final int? fiber;
  // final int? sugar;
  // final int? proteins;

  NutritionalFactsModel({
    this.calories,
    this.fat,
    this.saturatedFat,
    this.transFat,
    this.cholesterol,
    this.carbohydrates,
    this.sodium,
    this.fiber,
    this.sugar,
    this.proteins,
  });

  factory NutritionalFactsModel.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return NutritionalFactsModel(
      calories: double.parse(snapshot['calories']),
      fat: double.parse(snapshot['fat']),
      saturatedFat: double.parse(snapshot['saturatedFat']),
      transFat: double.parse(snapshot['transFat']),
      cholesterol: double.parse(snapshot['cholesterol']),
      carbohydrates: double.parse(snapshot['carbohydrates']),
      sodium: double.parse(snapshot['sodium']),
      fiber: double.parse(snapshot['fiber']),
      sugar: double.parse(snapshot['sugar']),
      proteins: double.parse(snapshot['proteins']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "calories": calories,
      "fat": fat,
      "saturatedFat": saturatedFat,
      "transFat": transFat,
      "cholesterol": cholesterol,
      "carbohydrates": carbohydrates,
      "sodium": sodium,
      "fiber": fiber,
      "sugar": sugar,
      "proteins": proteins,
    };
  }
}
