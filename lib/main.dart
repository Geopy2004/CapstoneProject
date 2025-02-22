import 'package:deped_reading_app/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:deped_reading_app/data/notifiers.dart'; // Ensure this file contains the `isDarkModeNotifier`
import 'pages/login_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'Deped Learning App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/', // This will navigate to the OnboardingPage first
          routes: {
            '/': (context) => OnboardingPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/widgetTree': (context) => WidgetTree(),          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
        );
      },
    );
  }
}
