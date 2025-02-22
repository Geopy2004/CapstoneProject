import 'dart:async';
import 'package:deped_reading_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deped_reading_app/data/notifiers.dart';

// Dummy Screens
import 'home_page.dart';
import 'profile_page.dart';
import 'test_page.dart';

// User model

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int _selectedIndex = 0; // Track selected tab

  // Fetch users from database

  // Logout confirmation dialog
  Future<void> _showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _showLoadingDialog();
                await _logoutUser();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Show loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text("Logging out..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Logout function
  Future<void> _logoutUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to log out: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Pages list
  final List<Widget> _pages = [
    HomePage(),
    TestPage(), // Home page
    ProfilePage(),
    SettingsPage(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reading App'),
            actions: [
              IconButton(
                onPressed: () {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                },
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _showLogoutConfirmation,
              ),
            ],
          ),
          body: _pages[_selectedIndex], // Change body based on selected index
          bottomNavigationBar: BottomNavigationBar(type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Test'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
