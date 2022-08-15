import 'package:flutter/material.dart';
import 'package:food_app/models/dish_ingredients.dart';

import '../models/dish_model.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class ModalFood extends StatefulWidget {
  final NetworkImage image;
  final DishModel dishModel;
  const ModalFood({
    Key? key,
    required this.image,
    required this.dishModel,
  }) : super(key: key);

  @override
  State<ModalFood> createState() => _ModalFoodState();
}

class _ModalFoodState extends State<ModalFood> {
  int amount = 1;
  int price = 0;
  List<DishIngredientsModel> addedToppings = [];
  late List<DishIngredientsModel> addedIngredients = addedToppings;
  List<DishIngredientsModel> removedIngredients = [];
  void calculatePrice(int amount) {
    this.price = 0;
    int extraIngredientsPrice = 0;
    for (int i = 0; i < addedToppings.length; i++) {
      if (addedToppings[i].added) {
        extraIngredientsPrice = extraIngredientsPrice + addedToppings[i].price!;
      }
    }
    print("total price for extra ${extraIngredientsPrice}");
    // print(
    //     "price for ${widget.dishModel.ingredients![0].name} \n ${widget.dishModel.ingredients![0].price}");
    this.price =
        (int.parse(widget.dishModel.price!) + extraIngredientsPrice) * amount;
  }

  List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
      return Item(
        headerValue: 'Panel $index',
        expandedValue: 'This is item number $index',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    addedToppings = widget.dishModel.ingredients!;
    calculatePrice(amount);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(widget.dishModel.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: widget.image,
              ),
              Text(
                widget.dishModel.description!,
              ),
              const Text(
                'Added',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      addedIngredients[index].isExpanded = !isExpanded;
                    });
                  },
                  children: addedIngredients
                      .map<ExpansionPanel>((DishIngredientsModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              removedIngredients.add(item);
                              addedIngredients.removeWhere(
                                (DishIngredientsModel currentItem) =>
                                    item == currentItem,
                              );
                              setState(() {
                                // for (int i = 0; i < addedToppings.length; i++) {
                                //   if (addedToppings[i].name == item.name) {
                                //     addedToppings[i].added = false;
                                //   }
                                // }
                              });
                            },
                          ),
                          title: Text(item.emoji! + " " + item.name!),
                        );
                      },
                      body: CheckboxListTile(
                        title: Text('Add extra ${item.name}'),
                        onChanged: (bool? value) {
                          item.added = value!;
                          for (int i = 0; i < addedToppings.length; i++) {
                            if (addedToppings[i].name == item.name) {
                              addedToppings[i].added = value;
                            }
                          }
                          // addedToppings
                          //     .where((DishIngredientsModel item) {
                          //       addedToppings
                          //     });
                          // addedToppings[1].added = value;
                          setState(() {});
                        },
                        value: item.added,
                      ),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
              const Text(
                'Removed',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      removedIngredients[index].isExpanded = !isExpanded;
                    });
                  },
                  children: removedIngredients
                      .map<ExpansionPanel>((DishIngredientsModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                addedIngredients.add(item);
                                removedIngredients.removeWhere(
                                    (DishIngredientsModel currentItem) =>
                                        item == currentItem);
                              });
                            },
                          ),
                          title: Text(item.emoji! + " " + item.name!),
                        );
                      },
                      body: const ListTile(
                        title: Center(
                          child: Text(
                            'This item has been removed',
                          ),
                        ),
                      ),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.blueGrey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (amount > 1) {
                      amount--;
                      // calculatePrice(amount);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text(
                    '-',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Text(amount.toString()),
                ElevatedButton(
                  onPressed: () {
                    if (amount < 15) {
                      amount++;
                      // calculatePrice(amount);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                child: Text('Pagar \$${price.toString()}'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
