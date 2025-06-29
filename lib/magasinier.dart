import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Identité du magasinier
  String matricule = '';
  String nom = '';

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Matricule : $matricule',
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Nom : $nom',
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                        ),
                      ],
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
                                setState(() {
                                  comptageControllers.add(TextEditingController());
                                });
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
                          debugPrint('Matricule : \$matricule');
                          debugPrint('Nom : \$nom');
                          debugPrint('Code Article : \${codesuiteController.text}');
                          debugPrint('Référence : \${referenceController.text}');
                          debugPrint('Désignation : \${designationController.text}');
                          debugPrint('Emplacement : \${emplacementController.text}');
                          for (int i = 0; i < comptageControllers.length; i++) {
                            debugPrint('Comptage \${i + 1} : \${comptageControllers[i].text}');
                          }
                          // TODO: envoyer les données au backend
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
}
