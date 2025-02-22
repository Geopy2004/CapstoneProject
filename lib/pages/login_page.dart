import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/notifiers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool _isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function with Firebase Authentication
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to log in with email and password using Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // If login is successful, navigate to home page (or dashboard)
      Navigator.pushReplacementNamed(context, '/widgetTree');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message if login fails
      _showErrorDialog(e.toString());
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                },
                icon: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (context, isDarkMode, child) {
                    return Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    );
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (builder, BoxConstraints constraints) {
                    return FractionallySizedBox(
                      widthFactor: screenWidth > 500 ? 0.5 : 1,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/logos/deped-logo-1.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Email Field
                          TextField(
                            controller: _emailController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 15),

                          // Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 25),

                          // Error Message
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),

                          // Login Button
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                          ),

                          // Register Button
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/register');
                            },
                            child: Text(
                              "Create an account",
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
