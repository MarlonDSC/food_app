import 'package:flutter/material.dart';
import 'package:food_app/services/firebase_firestore_methods.dart';
import 'package:food_app/screens/food_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/dish_ingredients.dart';
import '../models/dish_model.dart';
import '../providers/user_provider.dart';

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
    addedToppings = widget.dishModel.ingredients!;
    // calculateRating(widget.userProvider);
  }

  double calculateRating(UserProvider userProvider) {
    double liked = 0.0;
    double notLiked = 0.0;
    double ecuation = 0.0;
    List<DishIngredientsModel> likedIngredients = [];
    List<DishIngredientsModel> notLikedIngredients = [];
    for (int i = 0; i < addedToppings.length; i++) {
      for (int j = 0; j < userProvider.userModel.userIngredient!.length; j++) {
        if (addedToppings[i].name ==
            userProvider.userModel.userIngredient![j].name) {
          //pass percentage value from user to toppings
          addedToppings[i].percentage =
              userProvider.userModel.userIngredient![j].percentage!;
          //pass if ingredient should be avoided
          addedToppings[i].avoid =
              userProvider.userModel.userIngredient![j].avoid!;
          if (!addedToppings[i].primary!) {
            addedToppings[i].added =
                !userProvider.userModel.userIngredient![j].avoid!;
          }
        }
      }
    }

    for (int i = 0; i < addedToppings.length; i++) {
      print(
          '${addedToppings[i].name} ${addedToppings[i].avoid} ${addedToppings[i].percentage}');
    }
    likedIngredients = addedToppings.where((element) => element.avoid).toList();
    for (int i = 0; i < likedIngredients.length; i++) {
      liked = liked + likedIngredients[i].percentage.toDouble();
    }
    for (int i = 0; i < notLikedIngredients.length; i++) {
      notLiked = notLiked + notLikedIngredients[i].percentage.toDouble();
    }
    notLikedIngredients =
        addedToppings.where(((element) => !element.avoid)).toList();
    ecuation = liked - notLiked / (addedToppings.length * 100);

    return ecuation.abs();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    NetworkImage networkImage = NetworkImage(widget.dishModel.picture!);
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
                      '${(calculateRating(userProvider) * 100).toInt().toString()}%'),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      value: calculateRating(userProvider),
                    ),
                  ),
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
