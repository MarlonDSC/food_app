import 'package:flutter/cupertino.dart';
import 'package:food_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel userModel = UserModel(
    fullName: "",
    jobTitle: "",
    description: "",
    phoneNumber: "",
    profilePictureURL: "",
    liked: [],
    userIngredient: [],
  );
  UserProvider({required this.userModel});
  void readFromFirestore(UserModel userModel) {
    this.userModel = userModel;
    // notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
