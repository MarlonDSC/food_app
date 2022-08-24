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
    double ecuation = 0.0;
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

    /*
    primary are the main ingredients for a dish, for example a burger is not a burger
    if it doesn't contain a bun and a patty.

    How do I know if an ingredient is primary?
    Primary ingredients don't have the remove button and are "added ingredients" by
    default.
    
    left section:
      liked: is the total percentage of liked ingredients on the primary section
      notLiked: is the total percentage of ingredients food on the primary section
    right section:
      liked: is the total percentage of liked ingredients on the secondary section
      notLiked: is the total percentage of liked ingredients on the secondary section

    size: is the total amount of ingredients, counting primary and secondary ones.
    cuisine: is the cuisine the dish belongs to, for example a pizza belongs to the
    italian cuisine 🇮🇹

    
    (((liked*3-notLiked*5)+(liked-notLiked))/(size*0.75))+cuisine
    */
    List<int> primary = [0, 0];
    List<int> secondary = [0, 0];
    double cuisine = 0;
    for (int i = 0; i < addedToppings.length; i++) {
      if (addedToppings[i].primary! && !addedToppings[i].avoid) {
        primary[0] = primary[0] + addedToppings[i].percentage;
      } else if (addedToppings[i].primary! && addedToppings[i].avoid) {
        primary[1] = primary[1] + addedToppings[i].percentage;
      } else if (!addedToppings[i].primary! && !addedToppings[i].avoid) {
        secondary[0] = secondary[0] + addedToppings[i].percentage;
      } else if (!addedToppings[i].primary! && addedToppings[i].avoid) {
        secondary[1] = secondary[1] + addedToppings[i].percentage;
      }
    }
    userProvider.userModel.cuisine.contains(widget.dishModel.country!)
        ? cuisine = 0.15
        : cuisine = 0;
    ecuation =
        (((primary[0] * 3 - primary[1] * 5) + (secondary[0] - secondary[1])) /
                (addedToppings.length * 0.75)) +
            cuisine;
    return ecuation;
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
                      '${(calculateRating(userProvider) * 100).toInt().toString()} pts'),
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
