import 'package:flutter/material.dart';
import 'package:food_app/models/dish_ingredients.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/dish_model.dart';
import '../providers/user_provider.dart';

class FoodDetailScreen extends StatefulWidget {
  final NetworkImage image;
  final DishModel dishModel;
  final UserProvider userProvider;
  const FoodDetailScreen({
    Key? key,
    required this.image,
    required this.dishModel,
    required this.userProvider,
  }) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _ModalFoodState();
}

class _ModalFoodState extends State<FoodDetailScreen> {
  List<DishIngredientsModel> addedToppings = [];

  @override
  void initState() {
    super.initState();
    addedToppings = widget.dishModel.ingredients!;
    filterIngredientsToAvoid(widget.userProvider);
  }

  void calculatePrice() {
    // price = 0;
    int extraIngredientsPrice = 0;
    for (int i = 0; i < addedToppings.length; i++) {
      if (addedToppings[i].addedExtra) {
        extraIngredientsPrice = extraIngredientsPrice + addedToppings[i].price!;
      }
    }
    // print("total price for extra ${extraIngredientsPrice}");
    // print(
    //     "price for ${widget.dishModel.ingredients![0].name} \n ${widget.dishModel.ingredients![0].price}");
    widget.dishModel.totalPrice =
        (int.parse(widget.dishModel.price!) + extraIngredientsPrice) *
            widget.dishModel.amount;
  }

  void filterIngredientsToAvoid(UserProvider userProvider) {
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
  }

  Color filterColour(DishIngredientsModel item) {
    int colourCode = item.percentage * 10;
    item.avoid ? item.percentage : item.percentage = 0;
    print('${item.name} ${item.avoid} ${item.percentage}');
    if (item.avoid) {
      return Colors.red[colourCode]!;
    } else if (!item.avoid && item.percentage != 0) {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = context.read<UserProvider>();
    // addedToppings = widget.dishModel.ingredients!;
    CartProvider cartModel = Provider.of<CartProvider>(context);
    print(' products on cart ${cartModel.cartModel.total}');
    calculatePrice();
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Added',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    // addedToppings[index].isExpanded = !isExpanded;
                    List<DishIngredientsModel> addedToppingsTemp = addedToppings
                        .where(((element) => element.added == true))
                        .toList();
                    for (int i = 0; i < addedToppings.length; i++) {
                      if (addedToppings[i].name ==
                          addedToppingsTemp[index].name) {
                        addedToppings[i].isExpanded = !isExpanded;
                      }
                    }
                    setState(() {});
                  },
                  children: addedToppings
                      .where((element) => element.added == true)
                      .map<ExpansionPanel>((DishIngredientsModel item) {
                    return ExpansionPanel(
                      backgroundColor: filterColour(item),
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: item.primary!
                              ? const SizedBox()
                              : IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    for (int i = 0;
                                        i < addedToppings.length;
                                        i++) {
                                      if (addedToppings[i].name == item.name) {
                                        addedToppings[i].added = false;
                                        addedToppings[i].addedExtra = false;
                                        addedToppings[i].isExpanded = false;
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                          title: Text(
                            "${item.emoji!} ${item.name!}",
                            style: TextStyle(
                              color: item.percentage > 70
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                      body: item.extra!
                          ? CheckboxListTile(
                              title: Text('Add extra ${item.name}'),
                              subtitle: Text('\$${item.price}'),
                              onChanged: (bool? value) {
                                item.addedExtra = value!;
                                for (int i = 0; i < addedToppings.length; i++) {
                                  if (addedToppings[i].name == item.name) {
                                    addedToppings[i].addedExtra = value;
                                  }
                                }
                                setState(() {});
                              },
                              value: item.addedExtra,
                            )
                          : const ListTile(
                              title: Text(
                                'Cannot add more ingredients',
                              ),
                            ),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Removed',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {},
                  children: addedToppings
                      .where((element) => element.added == false)
                      .where((element) => element.topping == false)
                      .map<ExpansionPanel>((DishIngredientsModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              for (int i = 0; i < addedToppings.length; i++) {
                                if (addedToppings[i].name == item.name) {
                                  addedToppings[i].added = true;
                                }
                              }
                              setState(() {});
                            },
                          ),
                          title: Text("${item.emoji!} ${item.name!}"),
                        );
                      },
                      body: const ListTile(
                        title: Center(
                          child: Text(
                            'This item has been removed',
                          ),
                        ),
                      ),
                      // isExpanded: item.isExpanded,
                      isExpanded: false,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Toppings',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {},
                  children: addedToppings
                      .where((element) => element.added == false)
                      .where((element) => element.topping == true)
                      .map<ExpansionPanel>((DishIngredientsModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < addedToppings.length; i++) {
                                  if (addedToppings[i].name == item.name) {
                                    addedToppings[i].added = true;
                                  }
                                }
                              });
                            },
                          ),
                          title: Text("${item.emoji!} ${item.name!}"),
                        );
                      },
                      body: const ListTile(
                        title: Center(
                          child: Text(
                            'This item has been removed',
                          ),
                        ),
                      ),
                      // isExpanded: item.isExpanded,
                      isExpanded: false,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
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
                    if (widget.dishModel.amount > 1) {
                      widget.dishModel.amount--;
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
                Text(widget.dishModel.amount.toString()),
                ElevatedButton(
                  onPressed: () {
                    if (widget.dishModel.amount < 15) {
                      widget.dishModel.amount++;
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
                onPressed: () {
                  print(
                      'total amount due for this ${widget.dishModel.totalPrice}');
                  Provider.of<CartProvider>(context, listen: false)
                      .addToCart(widget.dishModel);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                child:
                    Text('Pagar \$${widget.dishModel.totalPrice.toString()}'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
