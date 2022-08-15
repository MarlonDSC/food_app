import 'package:flutter/cupertino.dart';
import 'package:food_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel userCard = UserModel(
    fullName: "",
    jobTitle: "",
    description: "",
    phoneNumber: "",
    profilePictureURL: "",
    liked: [],
    ingredientsToAvoid: [],
  );
  UserProvider({required this.userCard});
  void readFromFirestore(UserModel xuserCard) {
    userCard = xuserCard;
    // notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
