import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/food_card.dart';
import 'package:provider/provider.dart';

import '../models/filter_type.dart';
import '../models/dish_model.dart';
import '../models/user_provider.dart';
import '../utils/constants.dart';

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
    } else {
      return dishesCollection
          .where("type", isEqualTo: filterTypes.current)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    print('userProvider ${userProvider.userModel.liked.length}');
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
                // snapshot
                return Expanded(
                  // Vertical ListView
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      DishModel dishModel = DishModel.fromFirestore(data);
                      return FoodCard(
                        dishModel: dishModel,
                      );
                    }).toList(),
                  ),
                );
                // return FoodCard();
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text('No encontramos resultados'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text(
                    'Ocurrió un error, vuelve a intentarlo',
                  ),
                );
              }
            }),
      ],
    );
  }
}
