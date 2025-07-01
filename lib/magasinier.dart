// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // <-- À ajouter tout en haut


class MagasinierPage extends StatefulWidget {
  const MagasinierPage({super.key});

  @override
  State<MagasinierPage> createState() => _MagasinierPageState();
}

class _MagasinierPageState extends State<MagasinierPage> {
  // Contrôleurs fixes
  final TextEditingController codesuiteController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController emplacementController = TextEditingController();
   final TextEditingController matriculeController = TextEditingController();

  // Identité du magasinier
  String matricule = '';
  String nom = '';
  String mag = '';

  // Liste dynamique des contrôleurs de comptage
  List<TextEditingController> comptageControllers = [TextEditingController()];



  @override
  void initState() {
    super.initState();
    _loadMagasinierInfo();
  }



  Future<void> _loadMagasinierInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      matricule = prefs.getString('matricule') ?? 'Inconnu';
      nom = prefs.getString('Nm_Pr') ?? 'Inconnu';
      mag = prefs.getString('Id_mag1') ?? 'Inconnu';
    });
  }

  @override
  void dispose() {
    codesuiteController.dispose();
    referenceController.dispose();
    designationController.dispose();
    emplacementController.dispose();
    for (final c in comptageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildComptageField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: comptageControllers[index],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Comptage ${index + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          if (comptageControllers.length > 1)
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              tooltip: 'Supprimer ce champ',
              onPressed: () {
                setState(() {
                  comptageControllers[index].dispose();
                  comptageControllers.removeAt(index);
                });
              },
            ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

 Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  debugPrint("Déconnecté avec succès");
  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
}




  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false, // ← bloque le bouton retour
    child: Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.green,
  centerTitle: true,
  title: Text(
    'Magasinier',
    style: GoogleFonts.montserrat(color: Colors.white),
  ),
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
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Déconnexion',
      color: Colors.white,
      onPressed: _logout,
    ),
  ],
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
                    Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  color: Colors.green[50],
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.badge, color: Colors.green),
            const SizedBox(width: 8),
           TextField(
  controller: matriculeController,
  inputFormatters: [LowerCaseTextFormatter()], // <-- Ajout ici
  decoration: InputDecoration(
    labelText: 'Matricule',
    hintText: 'Ex : m12345',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    prefixIcon: const Icon(Icons.person),
  ),
),

            Text(
              matricule,
              style: GoogleFonts.montserrat(color: Colors.green[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.person, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Nom : ',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            Text(
              nom,
              style: GoogleFonts.montserrat(color: Colors.green[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.store, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Magasin : ',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            Text(
              mag,
              style: GoogleFonts.montserrat(color: Colors.green[800]),
            ),
          ],
        ),
      ],
    ),
  ),
),

                    const SizedBox(height: 20),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(
                          comptageControllers.length,
                          (index) => buildComptageField(index),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (comptageControllers.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red, size: 30),
                                tooltip: 'Supprimer le dernier champ',
                                onPressed: () {
                                  setState(() {
                                    comptageControllers.last.dispose();
                                    comptageControllers.removeLast();
                                  });
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 30),
                              tooltip: 'Ajouter un champ de comptage',
                              onPressed: () {
  if (comptageControllers.length < 2) {
    setState(() {
      comptageControllers.add(TextEditingController());
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nombre maximum de champs atteint')),
    );
  }
},
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
    ),);
  }
  
}
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
