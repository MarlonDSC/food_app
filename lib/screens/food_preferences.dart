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
              for (int i = 0;
                  i < filterTypes.filterType![index].userIngredient!.length;
                  i++) {
                // print(
                //     'selected ingredients ${filterTypes.filterType![index].userIngredient![i].name}');
                UserIngredientModel ingredientModel =
                    filterTypes.filterType![index].userIngredient![i];
                userProvider.userModel.userIngredient!.remove(ingredientModel);
              }
              filterTypes.filterType![index].isSelected = selected;
              filterTypes.current = filterTypes.filterType![index].label!;
              print(
                  "xd ${filterTypes.filterType![index].userIngredient!.length}");
              for (int i = 0;
                  i < filterTypes.filterType![index].userIngredient!.length;
                  i++) {
                // print(
                //     'selected ingredients ${filterTypes.filterType![index].userIngredient![i].name}');
                UserIngredientModel ingredientModel =
                    filterTypes.filterType![index].userIngredient![i];
                userProvider.userModel.userIngredient!.add(ingredientModel);
              }

              for (int i = 0;
                  i < userProvider.userModel.userIngredient!.length;
                  i++) {
                print(userProvider.userModel.userIngredient![i].name);
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
            // Text(specialNutrition.current!),
          ],
        ),
      ),
    );
  }
}
