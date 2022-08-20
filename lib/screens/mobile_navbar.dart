import 'package:flutter/material.dart';
import 'package:food_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/firebase_auth_methods.dart';
import 'mobile_home.dart';
import 'orders.dart';

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({Key? key}) : super(key: key);
  @override
  _MobileNavBarState createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar> {
  late String uid = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    uid = context.read<FirebaseAuthMethods>().user.uid;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(
                    enabled: true,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      floatingActionButton: cartProvider.cartModel.dish!.isEmpty
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () {
                print('{total price ${cartProvider.cartModel.total}}');
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        // unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: <BottomNavigationBarItem>[
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
              activeIcon: tabItem.icon,
            ),
        ],
      ),
    );
  }
}

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: const MobileHome(),
          icon: const Icon(
            Icons.home,
          ),
          title: "Home",
        ),
        TabNavigationItem(
          page: const Orders(),
          title: "My orders",
          icon: const Icon(
            Icons.receipt,
          ),
        ),
        // TabNavigationItem(
        //   // page: MobileCourses(),
        //   page: const HomeScreen(
        //     enabled: true,
        //   ),
        //   icon: const Icon(
        //     Icons.person,
        //   ),
        //   title: "My profile",
        // ),
        // TabNavigationItem(
        //   page: const Donate(key: null),
        //   icon: const Icon(
        //     CryptoFontIcons.BTC,
        //   ),
        //   title: "Donar",
        // ),
      ];
}
