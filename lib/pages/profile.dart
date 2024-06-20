import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/splash_screen.dart';
import 'package:brightnest_application/pages/change_password.dart';
import 'package:brightnest_application/pages/profile_edit.dart';
import 'package:brightnest_application/pages/about_us.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String username;

  const ProfilePage({super.key, required this.email, required this.username});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          final username = user.displayName ?? '';

          // Debugging statements
          print('ProfilePage - Email: $email');
          print('ProfilePage - Username: $username');

          return ProfileDisplay(email: email, username: username);
        }
        return Center(child: Text('No user logged in'));
      },
    );
  }
}

class ProfileDisplay extends StatelessWidget {
  final String email;
  final String username;

  const ProfileDisplay(
      {super.key, required this.email, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue200,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/image/user.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username.isEmpty ? 'No username set' : username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileOption(
              context,
              icon: Icons.person,
              iconColor: Colors.blue,
              text: "Edit Profil",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            email: email,
                            username: username,
                          )),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.lock,
              iconColor: Colors.blue,
              text: "Ubah Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.info,
              iconColor: Colors.blue,
              text: "Tentang Kami",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TentangKamiPage()),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.logout,
              iconColor: Colors.red,
              text: "Keluar",
              textColor: Colors.red,
              arrowColor: Colors.red,
              onTap: () async {
                // Handle Keluar action
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SplashScreen.id,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    Color arrowColor = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 15),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: arrowColor),
            ],
          ),
        ),
      ),
    );
  }
}
