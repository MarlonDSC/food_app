import 'dish_model.dart';

class CartModel {
  List<DishModel>? dish;
  int? total;
  CartModel({
    this.dish,
    this.total = 0,
  });
}
