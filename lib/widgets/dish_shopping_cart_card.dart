import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_app/models/models.dart';
import '../providers/cart_provider.dart';

class DishShoppingCartCard extends StatefulWidget {
  final DishModel dishModel;
  const DishShoppingCartCard({Key? key, required this.dishModel})
      : super(key: key);

  @override
  State<DishShoppingCartCard> createState() => _DishShoppingCartCardState();
}

class _DishShoppingCartCardState extends State<DishShoppingCartCard> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    controller.text = widget.dishModel.amount.toString();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: NetworkImage(widget.dishModel.picture!),
            ),
            // isThreeLine: true,
            title: Text(widget.dishModel.name!),
            subtitle: Text(
              "${widget.dishModel.amount} for \$${widget.dishModel.totalPrice}",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            trailing: Text('\$${widget.dishModel.totalPrice}'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: const Color(0xffF5F6FA),
                      // hintText: hintText,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {},
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 110,
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeFromCart(widget.dishModel);
                    // FireStoreMethods().likeFood(
                    //   widget.dishModel.id,
                    //   userProvider.userModel.id,
                    //   userProvider.userModel.liked,
                    // );
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
