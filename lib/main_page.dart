import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brightnest_application/color_schema.dart';
import 'package:brightnest_application/pages/home.dart';
import 'package:brightnest_application/pages/history.dart';
import 'package:brightnest_application/pages/profile.dart';

class MainPage extends StatefulWidget {
  final String email;

  const MainPage({super.key, required this.email});
  static String id = 'main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _pages = <Widget>[
      const HomePage(),
      const HistoryPage(),
      ProfilePage(
        email: widget.email,
        username: '',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _username = user?.displayName ?? '';
    });

    // Debugging statements
    print('MainPage - Email: ${widget.email}');
    print('MainPage - Username: $_username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: blue400,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
