import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/widgets/food_card.dart';
import 'package:provider/provider.dart';

import '../models/dish_ingredients.dart';
import '../models/filter_type.dart';
import '../models/dish_model.dart';
import '../providers/user_provider.dart';
import '../services/firebase_auth_methods.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class MobileHome extends StatefulWidget {
  static const routeName = 'MobileHome';
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PageController pageController = PageController(viewportFraction: 0.9);
  late FilterTypes filterType = FilterTypes(
    filterTypeChipList,
    0,
    filterTypeChipList[0].label,
  );
  final CollectionReference dishesCollection =
      FirebaseFirestore.instance.collection('dishes');
  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    super.initState();
    String uid = context.read<FirebaseAuthMethods>().user.uid;
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data()! as Map<String, dynamic>;
          UserModel userModel = UserModel.fromFirestore(data);
          Provider.of<UserProvider>(context, listen: false)
              .readFromFirestore(userModel);
          // ...
        },
        onError: (e) => print("Error getting document: $e"),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget buildListChoiceChips(FilterTypes filterTypes) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filterTypes.filterType!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(filterTypes.filterType![index].emoji!),
                const Text(' '),
                Text(
                  filterTypes.filterType![index].label!,
                  style: TextStyle(
                      color: filterTypes.filterType![index].label! ==
                              filterTypes.current
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
            selected: filterTypes.index == index,
            selectedColor: Colors.blue,
            onSelected: (bool selected) {
              setState(() {
                filterTypes.index = selected ? index : 0;
                filterTypes.current = filterTypes.filterType![index].label!;
              });
            },
            backgroundColor: Colors.blue[100],
            labelStyle: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> selectStream(
      UserProvider userProvider, FilterTypes filterTypes) {
    if (filterTypes.current == filterTypes.filterType![0].label) {
      return dishesCollection.snapshots();
    } else if (filterTypes.current == filterTypes.filterType![2].label &&
        userProvider.userModel.liked.isNotEmpty) {
      return dishesCollection
          .where(FieldPath.documentId, whereIn: userProvider.userModel.liked)
          .snapshots();
    } else if (filterType.current != filterType.filterType![1].label) {
      return dishesCollection
          .where("type", isEqualTo: filterTypes.current)
          .snapshots();
    } else {
      return dishesCollection.snapshots();
    }
  }

  List<Widget> _createCards(
    UserProvider userProvider,
    QuerySnapshot snapshot,
  ) {
    List<DishModel> dishModel = [];
    List<FoodCard> foodCards = [];
    for (var document in snapshot.docs) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      dishModel.add(
        DishModel.fromFirestore(data),
      );
      List<DishIngredientsModel> addedToppings = dishModel.last.ingredients!;
      dishModel.last.points = calculateRating(
        userProvider,
        addedToppings,
        dishModel.last.country!,
      );
      foodCards.add(FoodCard(dishModel: dishModel.last));
    }
    if (filterType.current == filterType.filterType![1].label) {
      foodCards
          // .where((element) => element.dishModel.points > 0)
          // .toList()
          .sort(((a, b) => b.dishModel.points.compareTo(a.dishModel.points)));
      if (foodCards.isNotEmpty) {
        return foodCards;
      } else {
        return [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'We couldn\'t find any recommended dishes for you 🙁, please reduce your standards XD',
              ),
            ),
          ),
        ];
      }
    }
    return foodCards;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    return Column(
      children: <Widget>[
        SizedBox(
          // Horizontal ListView
          height: 100,
          child: buildListChoiceChips(filterType),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: selectStream(userProvider, filterType),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  // Vertical ListView
                  child: ListView(
                    children: _createCards(userProvider, snapshot.data!),
                  ),
                );
                // return FoodCard();
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text('We couldn\'t find any results 🙁'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text(
                    'An error ocurred, please try again later ⏲️',
                  ),
                );
              }
            }),
      ],
    );
  }
}
