import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/models/user_provider.dart';
import 'package:food_app/screens/mobile_home.dart';
import 'package:food_app/screens/mobile_navbar.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/profile_screen.dart';
import 'screens/login_email_password_screen.dart';
import 'screens/signup_email_password_screen.dart';
import 'screens/website/read_profile.dart';
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
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Auth Demo',
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
        onGenerateRoute: (settings) {
          List<String> pathComponents = settings.name!.split('/');
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => ReadProfile(),
              );
            // break;
            default:
              return MaterialPageRoute(
                // builder: (context) => ReadProfile(
                //   args: pathComponents.last,
                // ),
                builder: (context) => ProfileScreen(
                  argument: pathComponents.last,
                  enabled: false,
                ),
              );
          }
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
