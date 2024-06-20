import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:brightnest_application/components/components.dart';
import 'package:brightnest_application/pages/login.dart';
import 'package:brightnest_application/pages/signup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String id = 'splash_screen';

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId:
            '1010801428667-6g1s3fgrbrphipr9dctoem3ff6n1b3ff.apps.googleusercontent.com',
      ).signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/image/splash.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'BrightNest',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Kilauan Kebersihan dengan Kemudahan di Ujung Jari',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Hero(
                          tag: 'login_btn',
                          child: CustomButton(
                            buttonText: 'Login',
                            onPressed: () {
                              Navigator.pushNamed(context, Login.id);
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Hero(
                          tag: 'signup_btn',
                          child: CustomButton(
                            buttonText: 'Sign Up',
                            isOutlined: true,
                            onPressed: () {
                              Navigator.pushNamed(context, SignUp.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Copyright © 2024 Developed by Rio & Arsa',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
