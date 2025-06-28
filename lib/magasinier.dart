import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MagasinierPage extends StatefulWidget {
  const MagasinierPage({super.key});

  @override
  State<MagasinierPage> createState() => _MagasinierPageState();
}

class _MagasinierPageState extends State<MagasinierPage> {
  final TextEditingController codesuiteController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController emplacementController = TextEditingController();
  final TextEditingController comptage1Controller = TextEditingController();
  final TextEditingController comptage2Controller = TextEditingController();
  final TextEditingController comptage3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Magasinier',
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
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Saisie d\'article',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildTextField('Code Article', codesuiteController),
                    const SizedBox(height: 20),

                    buildTextField('Référence Article', referenceController),
                    const SizedBox(height: 20),

                    buildTextField('Désignation', designationController),
                    const SizedBox(height: 20),

                    buildTextField('Emplacement', emplacementController),
                    const SizedBox(height: 20),

                    buildTextField('Comptage 1', comptage1Controller, isNumeric: true),
                    const SizedBox(height: 20),

                    buildTextField('Comptage 2', comptage2Controller, isNumeric: true),
                    const SizedBox(height: 20),

                    buildTextField('Comptage 3', comptage3Controller, isNumeric: true),
                    const SizedBox(height: 30),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Enregistrer',
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

  Widget buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
