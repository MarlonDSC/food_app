import 'package:food_app/models/avoid_ingredient.dart';

class UserModel {
  String id;
  final String? fullName;
  final String? jobTitle;
  final String? description;
  final String? phoneNumber;
  final String? profilePictureURL;
  final List liked;
  final List<AvoidIngredientModel>? ingredientsToAvoid;

  UserModel({
    this.id = '',
    required this.fullName,
    required this.jobTitle,
    required this.description,
    required this.phoneNumber,
    required this.profilePictureURL,
    required this.liked,
    required this.ingredientsToAvoid,
  });

  factory UserModel.fromFirestore(
    Map<String, dynamic> snapshot,
    // SnapshotOptions? options,
  ) {
    return UserModel(
      id: snapshot['id'],
      fullName: snapshot['fullName'],
      jobTitle: snapshot['jobTitle'],
      description: snapshot['description'],
      phoneNumber: snapshot['phoneNumber'],
      profilePictureURL: snapshot['profilePictureURL'],
      liked: snapshot['liked'],
      ingredientsToAvoid: snapshot['ingredientsToAvoid'] == null
          ? null
          : List<AvoidIngredientModel>.from(
              snapshot['ingredientsToAvoid'].map(
                (x) => AvoidIngredientModel.fromFirestore(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "fullName": fullName,
      "jobTitle": jobTitle,
      "description": description,
      "phoneNumber": phoneNumber,
      "profilePictureURL": profilePictureURL,
      "liked": liked,
      "ingredientsToAvoid": ingredientsToAvoid,
    };
  }
}
