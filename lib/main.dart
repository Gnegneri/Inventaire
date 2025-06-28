import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventaire1/admin.dart';
import 'package:inventaire1/magasinier.dart';
// importe ton LoginForm (change le chemin si nécessaire)
import 'login.dart';
// importe aussi tes pages admin et magasinier

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventaire des Pièces',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      // 1re option : définir directement l’écran d’accueil
      // home: const LoginForm(),

      // 2e option : utiliser un système de routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginForm(),
        '/magasinier': (context) => const MagasinierPage(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}
