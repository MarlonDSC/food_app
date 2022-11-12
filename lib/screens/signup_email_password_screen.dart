import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_methods.dart';
import '../utils/utils.dart';
import '../widgets/custom_textfield.dart';
import 'login_email_password_screen.dart';
import 'package:image_picker/image_picker.dart';

class EmailPasswordSignup extends StatefulWidget {
  static String routeName = '/signup';
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  State<EmailPasswordSignup> createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Uint8List localProfilePic = convertStringToUint8List("");
  bool isHidden = false;
  void signUpUser() async {
    String url = "";
    if (convertUint8ListToString(localProfilePic) != "") {
      url = await uploadImage(localProfilePic);
    }
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text,
          fullName: fullNameController.text,
          jobTitle: jobTitleController.text,
          description: descriptionController.text,
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
          profilePicURL: url,
          context: context,
        );
  }

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  convertUint8ListToString(localProfilePic) == ""
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.transparent,
                          child: Image.asset('images/profile_pic.png'),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.transparent,
                          backgroundImage: MemoryImage(localProfilePic),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () async {
                        localProfilePic = await pickImage(ImageSource.gallery);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            createUpdateProfile(
              fullNameController,
              jobTitleController,
              descriptionController,
              phoneNumberController,
              true,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: emailController,
                hintText: 'Ingresa tu correo',
                textInputType: TextInputType.emailAddress,
                obscureText: false,
                prefix: const Icon(Icons.mail),
                suffix: const SizedBox(),
                enabled: true,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: passwordController,
                hintText: 'Ingresa tu contraseña',
                textInputType: TextInputType.visiblePassword,
                obscureText: !isHidden,
                prefix: const SizedBox(),
                suffix: InkWell(
                  onTap: togglePasswordView,
                  child: Icon(
                    isHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                enabled: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: signUpUser,
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
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const EmailPasswordLogin(),
                  ),
                );
              },
              child: const Text('¿No tienes cuenta? Crea una'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
