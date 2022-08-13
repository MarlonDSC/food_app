class DishModel {
  String id;
  final String? name;
  final String? price;
  final int? description;
  final String? picture;
  final String? type;

  DishModel({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.picture,
    required this.type,
  });

  factory DishModel.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return DishModel(
      id: snapshot['id'],
      name: snapshot['name'],
      price: snapshot['price'],
      description: snapshot['description'],
      picture: snapshot['picture'],
      type: snapshot['type'],
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
    };
  }
}
