import 'package:flutter/cupertino.dart';
import 'package:food_app/models/user_ingredient_model.dart';
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
    cuisine: [],
  );
  UserProvider({required this.userModel});
  void readFromFirestore(UserModel userModel) {
    this.userModel = userModel;
    // notifyListeners();
  }

  void updateUserIngredients(
    List<UserIngredientModel> userIngredientModel,
  ) {
    userModel.userIngredient = userIngredientModel;
    notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
