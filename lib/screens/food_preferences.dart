import 'package:flutter/material.dart';
import 'package:food_app/models/user_ingredient_model.dart';
import 'package:provider/provider.dart';
import '../models/filter_type.dart';
import '../models/user_provider.dart';
import '../utils/constants.dart';
import '../widgets/medium_text.dart';

class FoodPreferences extends StatefulWidget {
  const FoodPreferences({Key? key}) : super(key: key);

  @override
  State<FoodPreferences> createState() => _FoodPreferencesState();
}

class _FoodPreferencesState extends State<FoodPreferences> {
  late FilterTypes specialNutrition = FilterTypes(
    specialNutritionChipList,
    0,
    specialNutritionChipList[0].label,
  );
  late FilterTypes religious = FilterTypes(
    religiousChipList,
    0,
    religiousChipList[0].label,
  );
  late FilterTypes diet = FilterTypes(
    dietChipList,
    0,
    dietChipList[0].label,
  );
  late FilterTypes cuisine = FilterTypes(
    cuisineChipList,
    0,
    cuisineChipList[0].label,
  );
  @override
  void initState() {
    super.initState();
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

  Widget buildWrapChoiceChips(
      FilterTypes filterTypes, UserProvider userProvider) {
    return Wrap(
      spacing: 8,
      runSpacing: 5.0,
      children:
          List<ChoiceChip>.generate(filterTypes.filterType!.length, (index) {
        return ChoiceChip(
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
                      : Colors.black,
                ),
              ),
            ],
          ),
          selected: filterTypes.index == index,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            setState(() {
              filterTypes.index = selected ? index : 0;
              filterTypes.current = filterTypes.filterType![index].label!;
              print(
                  "xd ${filterTypes.filterType![index].userIngredient!.length}");
              for (int i = 0;
                  i < filterTypes.filterType![index].userIngredient!.length;
                  i++) {
                print(
                    'selected ingredients ${filterTypes.filterType![index].userIngredient![i].name}');
              }
            });
          },
          backgroundColor: Colors.blue[100],
          labelStyle: const TextStyle(color: Colors.white),
        );
      }),
    );
  }

  Widget buildWrapFilterChips(
      FilterTypes filterTypes, UserProvider userProvider) {
    return Wrap(
      spacing: 8,
      runSpacing: 5.0,
      children:
          List<FilterChip>.generate(filterTypes.filterType!.length, (index) {
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(filterTypes.filterType![index].emoji!),
              const Text(' '),
              Text(
                filterTypes.filterType![index].label!,
                style: TextStyle(
                  color: filterTypes.filterType![index].isSelected!
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
          selected: filterTypes.filterType![index].isSelected!,
          selectedColor: Colors.blue,
          onSelected: (bool selected) {
            setState(() {
              // filterTypes.index = selected ? index : 0;
              // for (int i = 0;
              //     i < filterTypes.filterType![index].userIngredient!.length;
              //     i++) {
              //   // print(
              //   //     'selected ingredients ${filterTypes.filterType![index].userIngredient![i].name}');
              //   UserIngredientModel ingredientModel =
              //       filterTypes.filterType![index].userIngredient![i];
              //   // if()
              //   userProvider.userModel.userIngredient!.remove(ingredientModel);
              // }
              filterTypes.filterType![index].isSelected = selected;
              filterTypes.current = filterTypes.filterType![index].label!;

              for (int i = 0; i < filterTypes.filterType!.length; i++) {
                for (int j = 0;
                    j < filterTypes.filterType![i].userIngredient!.length;
                    j++) {
                  for (int k = 0;
                      k < userProvider.userModel.userIngredient!.length;
                      k++) {
                    userProvider.userModel.userIngredient!
                        .remove(filterTypes.filterType![i].userIngredient![j]);
                    if (filterTypes.filterType![i].isSelected! &&
                        !userProvider.userModel.userIngredient!.contains(
                            filterTypes.filterType![i].userIngredient![j])) {
                      userProvider.userModel.userIngredient!
                          .add(filterTypes.filterType![i].userIngredient![j]);
                    }
                  }
                }
                // if(filterTypes.filterType![i].isSelected)
              }

              // print(
              //     "xd ${filterTypes.filterType![index].userIngredient!.length}");
              // for (int i = 0;
              //     i < filterTypes.filterType![index].userIngredient!.length;
              //     i++) {
              //       if(filterTypes.filterType![index].userIngredient.is)
              //   UserIngredientModel ingredientModel =
              //       filterTypes.filterType![index].userIngredient![i];
              //   userProvider.userModel.userIngredient!.add(ingredientModel);
              // }

              // for (int i = 0;
              //     i < userProvider.userModel.userIngredient!.length;
              //     i++) {
              //   print(userProvider.userModel.userIngredient![i].name);
              // }
            });
          },
          backgroundColor: Colors.blue[100],
          labelStyle: const TextStyle(color: Colors.white),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const MediumText('Special nutrition'),
            SizedBox(
              height: 50,
              child: buildWrapFilterChips(specialNutrition, userProvider),
            ),
            const MediumText('Religious restrictions'),
            SizedBox(
              height: 100,
              child: buildWrapChoiceChips(religious, userProvider),
            ),
            const MediumText('Diet restrictions'),
            SizedBox(
              height: 100,
              child: buildWrapChoiceChips(diet, userProvider),
            ),
            const MediumText('Favourite cuisine'),
            SizedBox(
              height: 200,
              child: buildWrapFilterChips(cuisine, userProvider),
            ),
            Text('${userProvider.userModel.userIngredient!.length}'),
            Flexible(
              fit: FlexFit.loose,
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  // addedToppings[index].isExpanded = !isExpanded;
                  List<UserIngredientModel> addedToppingsTemp = userProvider
                      .userModel.userIngredient!
                      .where(((element) => element.avoid == false))
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
                    .map<ExpansionPanel>((UserIngredientModel item) {
                  int colourCode = item.percentage! * 10;
                  return ExpansionPanel(
                    backgroundColor: item.avoid!
                        ? Colors.primaries.first
                        : Colors.red[colourCode],
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        // tileColor:
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
            // Text(specialNutrition.current!),
          ],
        ),
      ),
    );
  }
}
