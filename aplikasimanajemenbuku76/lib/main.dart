import 'package:flutter/material.dart';
import '/ui/login_page.dart';
import '/ui/lokasi_rak_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        // Set Verdana as the default font for all text in the app
        fontFamily: 'Verdana',
        primarySwatch: Colors.blue, // Keep your primary color
      ),
      initialRoute: '/login', // Set initial route to the login page
      routes: {
        '/login': (context) => const LoginPage(), // Login route
        '/home': (context) => const LokasiRakPage(), // Home or LokasiRakPage route
      },
    );
  }
}
