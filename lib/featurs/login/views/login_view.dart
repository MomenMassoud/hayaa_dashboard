import 'package:dashboard/featurs/login/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String id = 'LoginView';
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GradientContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              colorOne: const Color.fromARGB(255, 255, 240, 195),
              colorTwo: Colors.white),
          const LoginViewBody(),
        ],
      ),
    );
  }
}
