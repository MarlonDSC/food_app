import 'package:flutter/material.dart';
import 'package:food_app/providers/cart_provider.dart';
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
                child: Text('Pagar \$${cartProvider.cartModel.total}'),
                onPressed: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
