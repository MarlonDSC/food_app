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

  void clearDish(DishModel dish) {
    dish.amount = 1;
    dish.totalPrice = 0;
    // for (int i = 0; i < dish.ingredients!.length; i++) {
    //   dish.ingredients![i].percentage = 0;
    //   dish.ingredients![i].avoid = false;
    //   dish.ingredients![i].added = true;
    //   dish.ingredients![i].addedExtra = false;
    //   dish.ingredients![i].isExpanded = false;
    // }
    notifyListeners();
  }

  void addToCart(
    DishModel dish,
  ) {
    cartModel.dish!.add(dish);
    cartModel.total = 0;
    for (int i = 0; i < cartModel.dish!.length; i++) {
      cartModel.total = cartModel.total! + cartModel.dish![i].totalPrice;
    }
    // cartModel.total = cartModel.total! + dish.totalPrice;
    notifyListeners();
  }

  void removeFromCart(DishModel dish) {
    cartModel.total = cartModel.total! - dish.totalPrice;
    // cartModel.total = 0;
    // for (int i = 0; i < cartModel.dish!.length; i++) {
    //   cartModel.total = cartModel.total! - cartModel.dish![i].totalPrice;
    // }
    cartModel.dish!.remove(dish);
    notifyListeners();
  }

  void clearCart() {
    cartModel.dish!.clear();
    cartModel.total = 0;
    notifyListeners();
  }

  void updateLikedFood(String foodId, String uid, List liked) {
    notifyListeners();
  }
}
