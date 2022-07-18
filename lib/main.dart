import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'screens/login_email_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_email_password_screen.dart';
import 'screens/website/read_profile.dart';
import 'screens/website/screen_arguments.dart';
import 'services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;

void main() async {
  print(Uri.base);
  String parameter1 = Uri.base.queryParameters["id"] ?? "";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(para1: parameter1),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.para1,
  }) : super(key: key);

  String para1;

  @override
  Widget build(BuildContext context) {
    print("id =" + para1);
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
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
          ReadProfile.routeName: (context) => ReadProfile(),
          // PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
        onGenerateRoute: (settings) {
          List<String> pathComponents = settings.name!.split('/');
          print("last " + pathComponents.last);
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => ReadProfile(),
              );
            // break;
            default:
              return MaterialPageRoute(
                builder: (context) => ReadProfile(
                  args: pathComponents.last,
                ),
              );
          }
        },
        // onGenerateRoute: (settings) {
        //   // print("settings" + settings.name!);
        //   final info = settings.arguments as ScreenArguments?;
        //   settings = settings.copyWith(
        //       name: settings.name! + "?id=" + info!.id, arguments: info);
        //   print("settings " + settings.name! + "\n" + info.id);
        //   return MaterialPageRoute(builder: (_) {
        //     return ReadProfile(
        //       args: info.id,
        //     );
        //   });
        // if (settings.name!.contains(ReadProfile.routeName)) {
        //   final args = settings.arguments as ScreenArguments;
        //   print("args on Main" + args.id);
        //   print("Param " + Uri.base.queryParameters['id']!);
        //   print("Param " + para1);
        //   return MaterialPageRoute(builder: (context) {
        //     return ReadProfile(
        //       // args: args.id,
        //       args: "x0GpqH3qHidbqp7dfCzD",
        //     );
        //   });
        // }
        // if(settings.name == PassArgui)
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
      return const HomeScreen();
    }
    return const EmailPasswordLogin();
  }
}
