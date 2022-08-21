import 'package:flutter/material.dart';
import 'package:food_app/models/user_ingredient_model.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/widgets/dish_shopping_cart_card.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping cart'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          // prevent the soft keyboard from covering text fields
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cartModel.dish!.length,
                itemBuilder: ((context, index) {
                  return DishShoppingCartCard(
                    dishModel: cartProvider.cartModel.dish![index],
                  );
                }),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: cartProvider.cartModel.total! > 0
                    ? () async {
                        for (int i = 0;
                            i < cartProvider.cartModel.dish!.length;
                            i++) {
                          for (int j = 0;
                              j <
                                  cartProvider
                                      .cartModel.dish![i].ingredients!.length;
                              j++) {
                            for (int k = 0;
                                k <
                                    userProvider
                                        .userModel.userIngredient!.length;
                                k++) {
                              if (cartProvider.cartModel.dish![i]
                                      .ingredients![j].name ==
                                  userProvider
                                      .userModel.userIngredient![k].name) {
                                if (cartProvider
                                    .cartModel.dish![i].ingredients![j].added) {
                                  if (cartProvider.cartModel.dish![i]
                                      .ingredients![j].addedExtra) {
                                    //add 10 points
                                    userProvider.userModel.userIngredient![k]
                                        .percentage = userProvider.userModel
                                            .userIngredient![k].percentage! +
                                        10;
                                  } else {
                                    //add 5 points
                                    userProvider.userModel.userIngredient![k]
                                        .percentage = userProvider.userModel
                                            .userIngredient![k].percentage! +
                                        5;
                                  }
                                } else {
                                  //reduce 5 ponts
                                  userProvider.userModel.userIngredient![k]
                                      .percentage = userProvider.userModel
                                          .userIngredient![k].percentage! -
                                      5;
                                }
                              } else {
                                UserIngredientModel userIngredientModel =
                                    UserIngredientModel(
                                  name: cartProvider
                                      .cartModel.dish![i].ingredients![j].name,
                                  percentage: 25,
                                  avoid: false,
                                );
                                // userProvider.userModel.userIngredient!
                                //     .contains(userIngredientModel);
                                print(
                                    'this element doesnt exist   ${userProvider.userModel.userIngredient!.where((element) => element.name == cartProvider.cartModel.dish![i].ingredients![j].name).toList()}');

                                var notExists = userProvider
                                    .userModel.userIngredient!
                                    .where((element) =>
                                        element.name !=
                                        cartProvider.cartModel.dish![i]
                                            .ingredients![j].name)
                                    .toList();

                                for (int i = 0; i < notExists.length; i++) {
                                  print('Doesnt exists ${notExists[i].name}');
                                }
                                // if (cartProvider
                                //     .cartModel.dish![i].ingredients![j].added) {
                                //   if (cartProvider.cartModel.dish![i]
                                //       .ingredients![j].addedExtra) {
                                //     print(
                                //         'added extra ${cartProvider.cartModel.dish![i].ingredients![j].name}');
                                //     UserIngredientModel userIngredientModel =
                                //         UserIngredientModel(
                                //       name: cartProvider.cartModel.dish![i]
                                //           .ingredients![j].name,
                                //       percentage: 25,
                                //       avoid: false,
                                //     );
                                //     userProvider.userModel.userIngredient!
                                //         .add(userIngredientModel);
                                //   } else {
                                //     print(
                                //         'added ${cartProvider.cartModel.dish![i].ingredients![j].name}');
                                //     UserIngredientModel userIngredientModel =
                                //         UserIngredientModel(
                                //       name: cartProvider.cartModel.dish![i]
                                //           .ingredients![j].name,
                                //       percentage: 15,
                                //       avoid: false,
                                //     );
                                //     userProvider.userModel.userIngredient![k]
                                //         .percentage = userProvider.userModel
                                //             .userIngredient![k].percentage! +
                                //         5;
                                //     userProvider.userModel.userIngredient!
                                //         .add(userIngredientModel);
                                //   }
                                // } else {
                                //   print(
                                //       'not added ${cartProvider.cartModel.dish![i].ingredients![j].name}');
                                //   UserIngredientModel userIngredientModel =
                                //       UserIngredientModel(
                                //     name: cartProvider.cartModel.dish![i]
                                //         .ingredients![j].name,
                                //     percentage: 15,
                                //     avoid: true,
                                //   );
                                //   userProvider.userModel.userIngredient!
                                //       .add(userIngredientModel);
                                // }
                              }
                            }
                            //   for(int l = 0; l<userProvider.userModel.userIngredient![k].){
                            // }
                            // if(cartProvider.cartModel.dish![i].ingredients![j].added){

                            // }
                          }
                        }
                        print(
                            'length is ${userProvider.userModel.userIngredient!.length}');
                        // for (int k = 0;
                        //     k < userProvider.userModel.userIngredient!.length;
                        //     k++) {
                        //   print(
                        //       '${userProvider.userModel.userIngredient![k].name}');
                        // }
                      }
                    : null,
                child: cartProvider.cartModel.total! > 0
                    ? Text('Pagar \$${cartProvider.cartModel.total}')
                    : const Text('Agrega un item al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
