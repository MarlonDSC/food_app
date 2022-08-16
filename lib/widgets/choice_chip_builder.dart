import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_app/models/filter_type.dart';
import 'package:food_app/screens/food_preferences.dart';

typedef void StringCallback(String val);

class ChoiceChipBuilder extends StatefulWidget {
  final FilterTypes filterTypes;
  final StringCallback callback;
  const ChoiceChipBuilder({
    Key? key,
    required this.filterTypes,
    required this.callback,
  }) : super(key: key);

  @override
  State<ChoiceChipBuilder> createState() => _ChoiceChipBuilderState();
}

class _ChoiceChipBuilderState extends State<ChoiceChipBuilder> {
  @override
  Widget build(BuildContext context) {
    // print('selected chip was: ${widget.filterTypes.current!}');
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.filterTypes.filterType!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.filterTypes.filterType![index].emoji!),
                const Text(' '),
                Text(widget.filterTypes.filterType![index].label!),
              ],
            ),
            selected: widget.filterTypes.index == index,
            selectedColor: Colors.blue,
            onSelected: (bool selected) {
              setState(() {
                widget.filterTypes.index = selected ? index : 0;
                widget.filterTypes.current =
                    widget.filterTypes.filterType![index].label!;
                // FoodPreferences.of(context).filterTypes.current = widget.filterTypes.current;
              });
            },
            backgroundColor: Colors.blueGrey[100],
            labelStyle: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
