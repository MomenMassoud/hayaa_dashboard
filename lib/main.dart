import 'package:dashboard/featurs/dashboard/views/dash_board_view.dart';
import 'package:dashboard/featurs/login/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCOv7lwHZUyMeUmzC6u5YGa_p4-iM4jcVw",
    projectId: "hayaa-161f5",
    messagingSenderId: "6809972591",
          authDomain: "hayaa-161f5.firebaseapp.com",
    appId: "1:6809972591:web:eceb902c615ea5bcaf029a",
        storageBucket: "hayaa-161f5.appspot.com",
          measurementId: "G-RG8MEH0L22"
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        LoginView.id: (context) => const LoginView(),
        DashBoardView.id: (context) => const DashBoardView(),
      },
      initialRoute: LoginView.id,
    );
  }
}
