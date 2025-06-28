// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    
  final String apiUrl = 'http://192.168.1.171/inventaire/login.php'; // IP de ton PC + chemin PHP

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'matricule': matriculeController.text,
        'password': passwordController.text,
      },
    );

    final result = jsonDecode(response.body);

if (response.statusCode == 200 && result['success']) {
  final role = result['Fonction'];

  if (role == 'admin') {
    Navigator.pushReplacementNamed(context, '/admin');
  } else if (role == 'magasinier') {
    Navigator.pushReplacementNamed(context, '/magasinier');
  } 
  }
  } catch (e) {
    // Erreur réseau (WAMP non démarré, pas connecté, etc.)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur réseau'),
        content: const Text("Impossible de se connecter au serveur. Vérifiez votre connexion ou si WAMP est lancé."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.green,
  centerTitle: true,
  title: Text(
    'Inventaire des Pièces',
    style: GoogleFonts.montserrat(color: Colors.white),
  ),
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
      ),
    ),
  ),
),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Connexion',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: matriculeController,
                      decoration: InputDecoration(
                        labelText: 'Matricule',
                        hintText: 'Ex: m17142',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Entrer votre mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Se connecter',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
}
