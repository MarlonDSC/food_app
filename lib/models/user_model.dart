import 'package:food_app/models/user_ingredient_model.dart';

class UserModel {
  String id;
  final String? fullName;
  final String? jobTitle;
  final String? description;
  final String? phoneNumber;
  final String? profilePictureURL;
  List liked;
  List<UserIngredientModel>? userIngredient;

  UserModel({
    this.id = '',
    required this.fullName,
    required this.jobTitle,
    required this.description,
    required this.phoneNumber,
    required this.profilePictureURL,
    required this.liked,
    required this.userIngredient,
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
      userIngredient: snapshot['userIngredient'] == null
          ? null
          : List<UserIngredientModel>.from(
              snapshot['userIngredient'].map(
                (x) => UserIngredientModel.fromFirestore(x),
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
      "userIngredient": userIngredient,
    };
  }
}
