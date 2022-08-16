import 'package:flutter/material.dart';
import '../models/filter_type.dart';
import '../utils/constants.dart';
import '../widgets/big_text.dart';
import '../widgets/choice_chip_builder.dart';
import '../widgets/medium_text.dart';

class FoodPreferences extends StatefulWidget {
  const FoodPreferences({Key? key}) : super(key: key);

  @override
  State<FoodPreferences> createState() => _FoodPreferencesState();
}

class _FoodPreferencesState extends State<FoodPreferences> {
  late FilterTypes specialNutrition = FilterTypes(
    chipsList,
    0,
    chipsList[0].label,
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

  Widget buildWrapChoiceChips(FilterTypes filterTypes) {
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
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('selected chip was: ${specialNutrition.current}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const BigText('Special nutrition'),
            SizedBox(
              // Horizontal ListView
              height: 100,
              child: buildWrapChoiceChips(specialNutrition),
              // child: ChoiceChipBuilder(
              //   filterTypes: specialNutrition,
              //   callback: (val) => {
              //     setState(() {
              //       specialNutrition.current = val;
              //     })
              //   },
              // ),
              // child: buildChoiceChips(
              //   chipsList,
              //   choiceIndex,
              //   selectedChip,
              // ),
            ),
            Text(specialNutrition.current!),
            // Text()
            MediumText('Special nutrition'),
            // ChoiceChip(
            //   label: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: <Widget>[Text('🍺'), Text('alcohol')],
            //   ),
            //   selected: true,
            // ),
          ],
        ),
      ),
    );
  }
}
