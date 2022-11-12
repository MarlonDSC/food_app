import 'package:flutter/material.dart';
import 'package:food_app/models/cart_model.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/mobile_home.dart';
import 'package:food_app/screens/mobile_navbar.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_email_password_screen.dart';
import 'screens/signup_email_password_screen.dart';
import 'services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(
            cartModel: CartModel(
              dish: [],
              total: 0,
            ),
          ),
        ),
        ListenableProvider<UserProvider>(
          create: (_) => UserProvider(
            userModel: UserModel(
              fullName: "",
              jobTitle: "",
              description: "",
              phoneNumber: "",
              profilePictureURL: "",
              liked: [],
              userIngredient: [],
              cuisine: [],
            ),
          ),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        title: 'Food App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        // home: const ReadProfile(),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          // ReadProfile.routeName: (context) => ReadProfile(),
          MobileHome.routeName: (context) => const MobileHome(),
          // PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const MobileNavBar();
    }
    return const EmailPasswordLogin();
  }
}
