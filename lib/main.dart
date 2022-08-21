import 'package:flutter/material.dart';
import 'package:food_app/models/models.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/screens.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
            ),
          ),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        initialRoute: "email_password_login",
        // initialRoute: "/",
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        // home: const ReadProfile(),
        routes: {
          // EmailPasswordSignup.routeName: (context) =>
          //     const EmailPasswordSignup(),
          // EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          // // ReadProfile.routeName: (context) => ReadProfile(),
          // MobileHome.routeName: (context) => const MobileHome(),
          // // PhoneScreen.routeName: (context) => const PhoneScreen(),

          'mobile_home': (_) => MobileHome(),
          'email_password_signup': (_) => EmailPasswordSignup(),
          'email_password_login': (_) => EmailPasswordLogin(),
        },
        // onGenerateRoute: (settings) {
        //   List<String> pathComponents = settings.name!.split('/');
        //   switch (settings.name) {
        //     case '/':
        //       return MaterialPageRoute(
        //         builder: (context) => ReadProfile(),
        //       );
        //     // break;
        //     default:
        //       return MaterialPageRoute(
        //         // builder: (context) => ReadProfile(
        //         //   args: pathComponents.last,
        //         // ),
        //         builder: (context) => ProfileScreen(
        //           argument: pathComponents.last,
        //           enabled: false,
        //         ),
        //       );
        //   }
        // },
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
