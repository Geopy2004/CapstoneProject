import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Registering... Please wait"),
            ],
          ),
        );
      },
    );
  }

  Future<void> _registerUser() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    _showLoadingDialog(); // Show loading dialog

    try {
      // Register user with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user ID
      String userId = userCredential.user!.uid;

      // Store user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullName': fullName,
        'email': email,
        'userId': userId,
        'role': 'student', // Default role
        'createdAt': Timestamp.now(), // Store the registration timestamp
      });

      Navigator.pop(context); // Close the loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("User registered successfully!"),
            backgroundColor: Colors.green),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to register: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
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
                const SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() =>
                          isConfirmPasswordVisible = !isConfirmPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Register", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
