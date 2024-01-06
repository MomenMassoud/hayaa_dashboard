import 'dart:developer';

import 'package:dashboard/featurs/dashboard/views/dash_board_view.dart';
import 'package:dashboard/featurs/login/widgets/custom_text_form_field.dart';
import 'package:dashboard/featurs/login/widgets/custom_text_form_field_2.dart';
import 'package:dashboard/featurs/login/widgets/gradiant_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({
    super.key,
  });

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.2,
              height: screenWidth * 0.2,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.cyanAccent, width: 2))),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  " Login To Your DashBoard",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: formkey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hideText: false,
                      screenWidth: screenWidth,
                      fielldRatio: 0,
                      hintText: "Admin Or Owner E-mail",
                      fieldIcon: const Icon(Icons.mail),
                      autovalidateMode: autovalidateMode,
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextFormFieldTwo(
                      hideText: true,
                      screenWidth: screenWidth,
                      fielldRatio: 0,
                      hintText: "Password",
                      fieldIcon: const Icon(Icons.password),
                      autovalidateMode: autovalidateMode,
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GradiantButton(
                        screenWidth: screenWidth,
                        buttonLabel: "Login",
                        onPressed: () async {
                          log(email);
                          final auth = FirebaseAuth.instance;
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            Navigator.pushNamed(context, DashBoardView.id);
                          } catch (e) {
                            print('Sign-in error: $e');
                          }
                        },
                        fontSize: 34)
                  ],
                )),
          ],
        )
      ],
    );
  }
}
