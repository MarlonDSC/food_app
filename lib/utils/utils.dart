// import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/dish_ingredients.dart';
import '../providers/user_provider.dart';
import '../services/storage_methods.dart';
import '../widgets/custom_textfield.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

Future<String> uploadImage(Uint8List file) async {
  try {
    return await StorageMethods()
        .uploadImageToStorage('profilePics', file, false);
  } catch (e) {
    return "";
  }
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

Column createUpdateProfile(
  TextEditingController fullNameController,
  TextEditingController jobTitleController,
  TextEditingController descriptionController,
  TextEditingController phoneNumberController,
  bool enabled,
) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: fullNameController,
          hintText: 'Ingresa tu nombre',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.person),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: jobTitleController,
          hintText: 'Ingresa tu puesto de trabajo',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.work),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: descriptionController,
          hintText: 'Ingresa una descripción',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.description),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: phoneNumberController,
          hintText: 'Ingresa tu número de teléfono',
          textInputType: TextInputType.phone,
          obscureText: false,
          prefix: const Icon(Icons.call),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

double gramTokCal(double fat, double saturatedFat, double transFat) {
  return (fat + saturatedFat + transFat) * 4;
}

bool isLowFat(double kCal, double totalkCal) {
  if (kCal / totalkCal > 0.30) {
    //It is not low fat
    print('it is not low fat');
    return false;
  } else {
    return true;
  }
}

bool isLowCarb(double kCal, double totalkCal) {
  if (kCal / totalkCal > 0.20) {
    //It is not low fat
    print('it is not low fat');
    return false;
  } else {
    return true;
  }
}

bool isHighProtein(double protein) {
  if (protein > 33) {
    //It is not low fat
    print('it is high protein');
    return true;
  } else {
    return false;
  }
}

bool isHighSodium(double sodium) {
  if (sodium > 350) {
    //It is not low fat
    print('it is high sodium');
    return true;
  } else {
    return false;
  }
}

bool isLowSodium(double sodium) {
  if (sodium <= 140) {
    //It is not low fat
    print('it is low sodium');
    return true;
  } else {
    return false;
  }
}

double calculateRating(UserProvider userProvider,
    List<DishIngredientsModel> addedToppings, String country) {
  double ecuation = 0.0;
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

  /*
    primary are the main ingredients for a dish, for example a burger is not a burger
    if it doesn't contain a bun and a patty.

    How do I know if an ingredient is primary?
    Primary ingredients don't have the remove button and are "added ingredients" by
    default.
    
    left section:
      liked: is the total percentage of liked ingredients on the primary section
      notLiked: is the total percentage of ingredients food on the primary section
    right section:
      liked: is the total percentage of liked ingredients on the secondary section
      notLiked: is the total percentage of liked ingredients on the secondary section

    size: is the total amount of ingredients, counting primary and secondary ones.
    cuisine: is the cuisine the dish belongs to, for example a pizza belongs to the
    italian cuisine 🇮🇹

    
    (((liked*3-notLiked*5)+(liked-notLiked))/(size*0.75))+cuisine
    */
  List<int> primary = [0, 0];
  List<int> secondary = [0, 0];
  double cuisine = 0;
  for (int i = 0; i < addedToppings.length; i++) {
    if (addedToppings[i].primary! && !addedToppings[i].avoid) {
      primary[0] = primary[0] + addedToppings[i].percentage;
    } else if (addedToppings[i].primary! && addedToppings[i].avoid) {
      primary[1] = primary[1] + addedToppings[i].percentage;
    } else if (!addedToppings[i].primary! && !addedToppings[i].avoid) {
      secondary[0] = secondary[0] + addedToppings[i].percentage;
    } else if (!addedToppings[i].primary! && addedToppings[i].avoid) {
      secondary[1] = secondary[1] + addedToppings[i].percentage;
    }
  }
  userProvider.userModel.cuisine.contains(country)
      ? cuisine = 0.15
      : cuisine = 0;
  ecuation =
      (((primary[0] * 3 - primary[1] * 5) + (secondary[0] - secondary[1])) /
              (addedToppings.length * 0.75)) +
          cuisine;
  return ecuation;
}
