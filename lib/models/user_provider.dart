import 'package:flutter/cupertino.dart';
import 'package:food_app/models/card_model.dart';

class UserProvider extends ChangeNotifier {
  UserCard userCard = UserCard(
    fullName: "",
    jobTitle: "",
    description: "",
    phoneNumber: "",
    profilePictureURL: "",
    liked: [],
  );
  UserProvider({required this.userCard});
  void readFromFirestore(UserCard xuserCard) {
    userCard = xuserCard;
    // notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
