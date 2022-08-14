class LikedFood {
  final String? id;

  LikedFood({
    required this.id,
  });

  factory LikedFood.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return LikedFood(
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
    };
  }
}
