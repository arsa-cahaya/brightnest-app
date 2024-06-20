import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brightnest_application/splash_screen.dart';
import 'package:brightnest_application/main_page.dart';
import 'package:brightnest_application/pages/login.dart';
import 'package:brightnest_application/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrightNest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainPage(
      //   email: '',
      // ),
      home: const AuthWrapper(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        MainPage.id: (context) => const MainPage(email: ''),
        Login.id: (context) => const Login(),
        SignUp.id: (context) => const SignUp(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return MainPage(
        email: firebaseUser.email ?? '',
      );
    } else {
      return const SplashScreen();
    }
  }
}
