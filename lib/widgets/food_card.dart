import 'package:flutter/material.dart';
import 'package:food_app/services/firebase_firestore_methods.dart';
import 'package:food_app/widgets/modal_food.dart';
import 'package:provider/provider.dart';

import '../models/dish_model.dart';
import '../models/user_provider.dart';

class FoodCard extends StatefulWidget {
  final DishModel dishModel;
  // final UserCard userCard;
  const FoodCard({
    Key? key,
    required this.dishModel,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    NetworkImage networkImage = NetworkImage(widget.dishModel.picture!);
    bool liked = false;
    if (userProvider.userCard.liked.contains(widget.dishModel.id)) {
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
              builder: (context) => ModalFood(
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
              trailing: IconButton(
                onPressed: () {
                  FireStoreMethods().likeFood(
                    widget.dishModel.id,
                    userProvider.userCard.id,
                    userProvider.userCard.liked,
                  );
                  setState(() {});
                },
                icon: Icon(
                  Icons.favorite,
                  color: liked ? Colors.red : Colors.grey,
                ),
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
