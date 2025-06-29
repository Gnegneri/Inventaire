// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// 🔐 Page de connexion complète – version mise à jour
// ---------------------------------------------------
// - Envoie matricule + mot de passe au backend PHP
// - Stocke matricule et nom dans SharedPreferences
// - Redirige selon le rôle renvoyé par l'API (Fonction)
// ---------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

Future<bool> isServerAvailable() async {
  const url = 'http://192.168.1.170/inventaire/ping.php';
  try {
    final response = await http
        .head(Uri.parse(url))                       // HEAD suffit
        .timeout(const Duration(seconds: 5));

    // Considérez toutes les réponses 2xx ou 3xx comme « serveur UP »
    return response.statusCode >= 200 &&
           response.statusCode < 400;
  } on SocketException {
    // Adresse injoignable (Wi‑Fi coupé, IP fausse…)
    return false;
  } on TimeoutException {
    return false;
  } catch (_) {
    return false;
  }
}

  

Future<void> showMessage(String titre, String message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titre),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _loginUser() async {
  final String matricule = matriculeController.text.trim();
  final String motDePasse = passwordController.text.trim();


  if (matricule.isEmpty || motDePasse.isEmpty) {
    await showMessage('Erreur', 'Veuillez remplir tous les champs');
    return;
  }


try {

final url = Uri.parse('http://192.168.1.170/inventaire/login.php');
    final response = await http
        .post(url, body: {'matricule': matricule, 'Mot_pass': motDePasse})
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      await showMessage('Erreur', 'Le serveur répond, mais renvoie ${response.statusCode}.');
      return;
    }

    final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('matricule', data['matricule']);
        await prefs.setString('Nm_Pr', data['Nm_Pr']);

        if (data['Fonction'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (data['Fonction'] == 'magasinier') {
          Navigator.pushReplacementNamed(context, '/magasinier');
        } else {
          await showMessage('Erreur', 'Rôle inconnu : ${data['Fonction']}');
        }
      } else {
        await showMessage('Erreur', data['message'] ?? 'Identifiants invalides');
      }
    }
  catch (e) {
    await showMessage('Erreur', 'Erreur réseau : $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Inventaire des Pièces', style: GoogleFonts.montserrat()),
         leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: 60,
            height: 60,
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Connexion',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        )),
                    const SizedBox(height: 30),

                    // Champ matricule
                    TextField(
                      controller: matriculeController,
                      decoration: InputDecoration(
                        labelText: 'Matricule',
                        hintText: 'Ex : M12345',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Champ mot de passe
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Votre mot de passe',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:  _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Se connecter',
                                style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
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
