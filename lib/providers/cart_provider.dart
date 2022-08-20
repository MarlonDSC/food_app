import 'package:flutter/cupertino.dart';
import '../models/cart_model.dart';
import '../models/dish_model.dart';

class CartProvider extends ChangeNotifier {
  CartModel cartModel = CartModel(
    dish: [],
    total: 0,
  );

  CartProvider({required this.cartModel});
  void readFromFirestore(CartModel cartModel) {
    cartModel = cartModel;
    // notifyListeners();
  }

  void updateCart(
    DishModel dish,
  ) {
    cartModel.dish!.add(dish);
    cartModel.total = cartModel.total! + dish.totalPrice;
    notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
