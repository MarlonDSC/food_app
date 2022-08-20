import 'package:flutter/material.dart';
import 'package:food_app/models/user_ingredient_model.dart';
import 'package:provider/provider.dart';
import '../models/filter_type.dart';
import '../providers/user_provider.dart';
import '../services/firebase_firestore_methods.dart';
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
  // List<UserIngredientModel> userProvider.userModel.userIngredient! = [];
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
              // filterTypes.index = selected ? index : 0;
              // filterTypes.current = filterTypes.filterType![index].label!;
              // print(
              //     "xd ${filterTypes.filterType![index].userIngredient!.length}");
              // for (int i = 0;
              //     i < filterTypes.filterType![index].userIngredient!.length;
              //     i++) {
              //   print(
              //       'selected ingredients ${filterTypes.filterType![index].userIngredient![i].name}');
              // }

              filterTypes.index = selected ? index : 0;
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
                    if (filterTypes.current ==
                            filterTypes.filterType![i].label! &&
                        !userProvider.userModel.userIngredient!.contains(
                          filterTypes.filterType![i].userIngredient![j],
                        ) &&
                        filterTypes.filterType![i].userIngredient![j].name !=
                            '') {
                      userProvider.userModel.userIngredient!
                          .add(filterTypes.filterType![i].userIngredient![j]);
                    }
                  }
                }
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
              }
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
    // convertClasses(userProvider.userModel.userIngredient!, userProvider.userModel.userIngredient!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Preferences'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Provider.of<UserProvider>(context, listen: false)
          //     .updateUserIngredients(
          //   userProvider.userModel.userIngredient!,
          // );
          FireStoreMethods().likeUserIngredient(
            userProvider.userModel.userIngredient!,
            userProvider.userModel.id,
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const MediumText('Special nutrition'),
              SizedBox(
                height: 50,
                child: buildWrapFilterChips(specialNutrition, userProvider),
              ),
              const SizedBox(
                height: 25,
              ),
              const MediumText('Religious restrictions'),
              SizedBox(
                height: 100,
                child: buildWrapChoiceChips(religious, userProvider),
              ),
              const SizedBox(
                height: 25,
              ),
              const MediumText('Diet restrictions'),
              SizedBox(
                height: 100,
                child: buildWrapChoiceChips(diet, userProvider),
              ),
              const SizedBox(
                height: 25,
              ),
              const MediumText('Favourite cuisine'),
              SizedBox(
                height: 100,
                child: buildWrapFilterChips(cuisine, userProvider),
              ),
              const SizedBox(
                height: 25,
              ),
              // Text('${userProvider.userModel.userIngredient!.length}'),
              const Text(
                'Liked',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    List<UserIngredientModel> userIngredientTemp = userProvider
                        .userModel.userIngredient!
                        .where(((element) => element.avoid == false))
                        .toList();
                    print(
                        'size of userIngredientModel ${userIngredientTemp.length}');
                    for (int i = 0; i < userIngredientTemp.length; i++) {
                      if (userIngredientTemp[i].name ==
                          userIngredientTemp[index].name) {
                        userIngredientTemp[i].isExpanded = !isExpanded;
                      }
                    }
                    setState(() {});
                  },
                  children: userProvider.userModel.userIngredient!
                      .where((element) => element.avoid == false)
                      .map<ExpansionPanel>((UserIngredientModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              for (int i = 0;
                                  i <
                                      userProvider
                                          .userModel.userIngredient!.length;
                                  i++) {
                                if (userProvider
                                        .userModel.userIngredient![i].name ==
                                    item.name) {
                                  userProvider.userModel.userIngredient![i]
                                      .avoid = true;
                                }
                              }
                              setState(() {});
                            },
                          ),
                          title: Text("${item.name!} ${item.percentage}%"),
                        );
                      },
                      body: ListTile(
                        title: Center(
                            child: Slider(
                          min: 10.0,
                          max: 100.0,
                          divisions: 9,
                          label: '${item.percentage!}',
                          value: item.percentage!.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              item.percentage = value.toInt();
                            });
                          },
                        )),
                      ),
                      // isExpanded: item.isExpanded,
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Not Liked',
                style: TextStyle(fontSize: 30),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    List<UserIngredientModel> userIngredientTemp = userProvider
                        .userModel.userIngredient!
                        .where(((element) => element.avoid == true))
                        .toList();
                    print(
                        'size of userIngredientModel ${userIngredientTemp.length}');
                    for (int i = 0; i < userIngredientTemp.length; i++) {
                      if (userIngredientTemp[i].name ==
                          userIngredientTemp[index].name) {
                        userIngredientTemp[i].isExpanded = !isExpanded;
                      }
                    }
                    setState(() {});
                  },
                  children: userProvider.userModel.userIngredient!
                      .where((element) => element.avoid == true)
                      .map<ExpansionPanel>((UserIngredientModel item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              for (int i = 0;
                                  i <
                                      userProvider
                                          .userModel.userIngredient!.length;
                                  i++) {
                                if (userProvider
                                        .userModel.userIngredient![i].name ==
                                    item.name) {
                                  userProvider.userModel.userIngredient![i]
                                      .avoid = false;
                                }
                              }
                              setState(() {});
                            },
                          ),
                          title: Text("${item.name!} ${item.percentage}%"),
                        );
                      },
                      body: ListTile(
                        title: Center(
                            child: Slider(
                          min: 10.0,
                          max: 100.0,
                          divisions: 9,
                          label: '${item.percentage!}',
                          value: item.percentage!.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              item.percentage = value.toInt();
                            });
                          },
                        )),
                      ),
                      // isExpanded: item.isExpanded,
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
