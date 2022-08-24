import 'package:flutter/material.dart';
import 'package:food_app/services/firebase_firestore_methods.dart';
import 'package:food_app/screens/food_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/dish_ingredients.dart';
import '../models/dish_model.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class FoodCard extends StatefulWidget {
  final DishModel dishModel;
  // final UserModel userModel;
  const FoodCard({
    Key? key,
    required this.dishModel,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  List<DishIngredientsModel> addedToppings = [];
  @override
  void initState() {
    super.initState();
    // calculateRating(widget.userProvider);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    NetworkImage networkImage = NetworkImage(widget.dishModel.picture!);
    addedToppings = widget.dishModel.ingredients!;
    bool liked = false;
    if (userProvider.userModel.liked.contains(widget.dishModel.id)) {
      liked = true;
    } else {
      liked = false;
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(
                image: networkImage,
                dishModel: widget.dishModel,
                userProvider: userProvider,
              ),
            ),
          );
          // await showModalBottomSheet(
          //   enableDrag: true,
          //   isScrollControlled: true,
          //   context: context,
          //   builder: (context) => ModalFood(
          //     image: networkImage,
          //     dishModel: widget.dishModel,
          //   ),
          // );
        },
        child: Column(
          children: [
            ListTile(
              leading: Image(
                image: networkImage,
              ),
              // isThreeLine: true,
              title: Text(widget.dishModel.name!),
              subtitle: Text(
                "\$${widget.dishModel.price!}",
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // '${(calculateRating(userProvider, addedToppings, widget.dishModel.country!) * 100).toInt().toString()} pts'),
                    '${(widget.dishModel.points).toInt().toString()}%',
                    style: TextStyle(
                      color: widget.dishModel.points > 0
                          ? Colors.black
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // SizedBox(
                  //   width: 25,
                  //   height: 25,
                  //   child: CircularProgressIndicator(
                  //     value: calculateRating(userProvider),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () {
                      FireStoreMethods().likeFood(
                        widget.dishModel.id,
                        userProvider.userModel.id,
                        userProvider.userModel.liked,
                      );
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: liked ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.dishModel.description!,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
