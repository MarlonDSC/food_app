import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/food_card.dart';
import 'package:provider/provider.dart';

import '../models/filter_type.dart';
import '../models/dish_model.dart';
import '../models/user_provider.dart';

class MobileHome extends StatefulWidget {
  static const routeName = 'MobileHome';
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PageController pageController = PageController(viewportFraction: 0.9);
  final List<FilterType> _chipsList = [
    FilterType("All", false),
    FilterType("Recommended", false),
    FilterType("Liked", false),
    FilterType("Pasta", false),
    FilterType("Pizza", false),
    FilterType("Burger", false),
  ];
  bool selected = false;
  int choiceIndex = 0;
  String selectedChip = 'All';
  final CollectionReference dishesCollection =
      FirebaseFirestore.instance.collection('dishes');
  late Stream<QuerySnapshot> stream;
  // String selectedChip = _chipsList[choiceIndex].label!;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget _buildChoiceChips() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _chipsList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: Text(_chipsList[index].label!),
            selected: choiceIndex == index,
            selectedColor: Colors.blue,
            onSelected: (bool selected) {
              setState(() {
                choiceIndex = selected ? index : 0;
                selectedChip = _chipsList[index].label!;
              });
            },
            backgroundColor: Colors.blueGrey,
            labelStyle: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  List<Widget> filterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_chipsList[i].label!),
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          selected: _chipsList[i].isSelected!,
          onSelected: (bool value) {
            setState(() {
              choiceIndex = _chipsList[i].isSelected! ? i : 0;
              _chipsList[i].isSelected = value;
              selectedChip = _chipsList[i].label!;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Stream<QuerySnapshot> selectStream(UserProvider userProvider) {
    if (selectedChip == _chipsList[0].label) {
      return dishesCollection.snapshots();
    } else if (selectedChip == _chipsList[2].label &&
        userProvider.userCard.liked.isNotEmpty) {
      return dishesCollection
          .where(FieldPath.documentId, whereIn: userProvider.userCard.liked)
          .snapshots();
    } else {
      return dishesCollection
          .where("type", isEqualTo: selectedChip)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    return Column(
      children: <Widget>[
        SizedBox(
          // Horizontal ListView
          height: 100,
          child: _buildChoiceChips(),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: selectStream(userProvider),
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
