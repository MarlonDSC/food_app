import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/widgets/food_card.dart';

import '../models/filter_type.dart';
import '../models/dish_model.dart';

class MobileHome extends StatefulWidget {
  static const routeName = 'MobileHome';
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PageController pageController = PageController(viewportFraction: 0.9);
  final List<FilterType> _chipsList = [
    FilterType("Todos", false),
    FilterType("Recomendado", false),
    FilterType("Pasta", false),
    FilterType("Pizza", false),
    FilterType("Hamburgesa", false),
  ];
  bool selected = false;
  int choiceIndex = 0;
  String selectedChip = 'Todos';
  final CollectionReference dishesCollection =
      FirebaseFirestore.instance.collection('dishes');
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
            selectedColor: Colors.red,
            onSelected: (bool selected) {
              setState(() {
                choiceIndex = selected ? index : 0;
                selectedChip = _chipsList[index].label!;
                print(selectedChip);
              });
            },
            backgroundColor: Colors.green,
            labelStyle: TextStyle(color: Colors.white),
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
          selected: choiceIndex == _chipsList[i].isSelected!,
          onSelected: (bool value) {
            setState(() {
              choiceIndex = _chipsList[i].isSelected! ? i : 0;
              _chipsList[i].isSelected = value;
              selectedChip = _chipsList[i].label!;
              print(selectedChip);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          // Horizontal ListView
          height: 100,
          child: _buildChoiceChips(),
          // child: ListView.builder(
          //   itemCount: 1,
          //   scrollDirection: Axis.horizontal,
          //   itemBuilder: (context, index) {
          //     return Row(
          //       children: filterChips(),
          //     );
          //   },
          // ),
        ),
        // SizedBox(
        //   // Horizontal ListView
        //   height: 100,
        //   child: ListView.builder(
        //     itemCount: 20,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       return Container(
        //         width: 100,
        //         alignment: Alignment.center,
        //         color: Colors.blue[(index % 9) * 100],
        //         child: Text(index.toString()),
        //       );
        //     },
        //   ),
        // ),
        // const SizedBox(
        //   height: 50,
        // ),
        StreamBuilder<QuerySnapshot>(
            stream: selectedChip == "Todos"
                ? dishesCollection.snapshots()
                : dishesCollection
                    .where("type", isEqualTo: selectedChip)
                    .snapshots(),
            builder: (context, snapshot) {
              return Expanded(
                // Vertical ListView
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return FoodCard();
                  },
                ),
              );
            }),
      ],
    );
  }
}
