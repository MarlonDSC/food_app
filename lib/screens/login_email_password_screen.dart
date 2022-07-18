import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_methods.dart';
import '../widgets/custom_textfield.dart';
import 'signup_email_password_screen.dart';
import 'website/read_profile.dart';
import 'website/screen_arguments.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login';
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: loginUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmailPasswordSignup(),
                ),
              );
            },
            child: const Text('¿No tienes cuenta? Crea una'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ReadProfile.routeName,
                arguments: ScreenArguments(
                  'x0GpqH3qHidbqp7dfCzD',
                ),
              );
            },
            child: const Text('Access to a user'),
          ),
        ],
      ),
    );
  }
}
