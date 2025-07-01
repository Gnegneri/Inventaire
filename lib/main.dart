import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';
import 'magasinier.dart';
import 'admin.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventaire des Pièces',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => const LoginPage(),
        '/admin': (context) => const AdminPage(),
        '/magasinier': (context) => const MagasinierPage(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
