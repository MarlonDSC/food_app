import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        color: Colors.orange,
        child: Row(
          children: [
            Expanded(
              flex: 33,
              child: Image.network(
                'https://picsum.photos/250?image=9',
              ),
            ),
            Expanded(
              flex: 66,
              child: Column(
                children: const [
                  Expanded(
                    flex: 50,
                    child: Center(child: Text('abc')),
                  ),
                  Expanded(flex: 25, child: Text('def')),
                  Expanded(flex: 25, child: Text('ghi')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
