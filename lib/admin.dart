import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interface Administrateur',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: Padding(
  padding: const EdgeInsets.all(4.0), // Moins de padding pour laisser plus de place
  child: SizedBox(
    width: 60, // ← augmenté
    height: 60, // ← augmenté
    child: Image.asset(
      'assets/logo.png',
      fit: BoxFit.contain,
    ),
  ),
),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bienvenue, Administrateur',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 40),

                    buildAdminButton(
                      label: 'Insérer le stock',
                      icon: Icons.add_box,
                      onPressed: () {
                      },
                    ),
                    const SizedBox(height: 20),

                    buildAdminButton(
                      label: 'Extraire le stock',
                      icon: Icons.download,
                      onPressed: () {
                      },
                    ),
                    const SizedBox(height: 20),

                    buildAdminButton(
                      label: 'Ajouter un utilisateur',
                      icon: Icons.person_add,
                      onPressed: () {
                      },
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

  Widget buildAdminButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
