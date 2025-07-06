// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MagasinierPage extends StatefulWidget {
  const MagasinierPage({super.key});

  @override
  State<MagasinierPage> createState() => _MagasinierPageState();
}

class _MagasinierPageState extends State<MagasinierPage> {
/* ------------------- Controllers ------------------- */
  final codesuiteController     = TextEditingController();
  final referenceController     = TextEditingController();
  final designationController   = TextEditingController();
  final emplacementController   = TextEditingController();
  final comptageControllers = <TextEditingController>[
  TextEditingController(), // Comptage 1
  TextEditingController(), // Comptage 2
];


/* ------------------- Identité magasinier ------------------- */
  String matricule = '';
  String nom       = '';
  String mag       = '';
  bool showComptage2 = false; // ← pour afficher ou masquer le champ 2


/* ------------------- Débounce ------------------- */
  Timer? _debounce;
  

/* =================== INIT / DISPOSE =================== */
  @override
  void initState() {
    super.initState();
    _loadMagasinierInfo();
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
    _debounce?.cancel();
    super.dispose();
  }

/* ------------------- UI helpers ------------------- */
  Future<void> _showDialog(String titre, String message) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titre),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
      ),
    );
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    codesuiteController.clear();
    referenceController.clear();
    designationController.clear();
    emplacementController.clear();
    for (final c in comptageControllers) {
  c.clear();
}
setState(() {
  showComptage2 = false;
});

  }

/* ============== Récupération infos magasinier ============== */
  Future<void> _loadMagasinierInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      matricule = prefs.getString('matricule') ?? 'Inconnu';
      nom       = prefs.getString('Nm_Pr')     ?? 'Inconnu';
      mag       = prefs.getString('Id_mag1')   ?? 'Inconnu';
    });
  }

/* =================== API : get_article =================== */
  Future<void> _fetchArticleData(String rawCode) async {
    final code = rawCode.trim();


    try {
      final response = await http.post(
        Uri.parse('http://172.16.5.123/inventaire/get_article.php'),
        headers: {'Accept': 'application/json'},
        body: {'Code_Suite': code},          // ← encodé en x‑www‑form‑urlencoded
      );

      if (response.statusCode != 200) {
        _showDialog('Erreur', 'Erreur serveur : ${response.statusCode}');
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        setState(() {
          referenceController.text   = data['An_ref']      ?? '';
          designationController.text = data['Designation'] ?? '';
          emplacementController.text = data['Empl']        ?? '';
        });
      } else {
        _showDialog('Information', data['message'] ?? 'Article introuvable');
        _clearFields();
      }
    } catch (e) {
      _showDialog('Erreur', 'Erreur de connexion : $e');
    }
  }

/* =================== Enregistrement stock =================== */
  Future<void> _enregistrerStock() async {
  final url = Uri.parse('http://172.16.5.123/inventaire/enregistrer.php');

  final comptage1 = comptageControllers[0].text.trim();
  final comptage2 = comptageControllers[1].text.trim();

  final body = {
    'code'      : codesuiteController.text.trim(),
    'matricule' : matricule,
    'magasin'   : mag,
  };

  // 🔄 Logique métier : priorité à comptage2 s’il est rempli
  if (comptage2.isNotEmpty) {
    body['comptage2'] = comptage2;
  } else if (comptage1.isNotEmpty) {
    body['comptage1'] = comptage1;
  } else {
    await showMessage('Erreur', 'Veuillez remplir au moins un comptage');
    return;
  }

  try {
    final res = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: body,
    );

    print('Réponse brute : ${res.body}');

    if (res.statusCode != 200) {
      await showMessage('Erreur', 'Erreur serveur : ${res.statusCode}');
      _clearFields();
      return;
    }

    final json = jsonDecode(res.body);
    if (json['status'] == 'success') {
      await showMessage('Info', 'Stock enregistré ✔');
    } else {
      await showMessage('Erreur', json['message'] ?? 'Erreur inconnue');
    }

  } catch (e) {
    await showMessage('Erreur', 'Erreur de connexion ou JSON : $e');
  } finally {
    _clearFields();
  }
}



/* =================== LOGOUT =================== */
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
  }

/* =================== BUILD =================== */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Magasinier', style: GoogleFonts.montserrat(color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout)],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: wide ? 600 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /* ----------- Carte identité ----------- */
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _infoRow(Icons.badge,  'Matricule', matricule),
                            _infoRow(Icons.person, 'Nom',       nom),
                            _infoRow(Icons.store,  'Magasin',   mag),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text('Saisie d\'article',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[800])),
                    const SizedBox(height: 30),

                    /* ----------- Code Article ----------- */
                    Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) async {
    final code = textEditingValue.text.trim();

    if (code.length < 3) return const Iterable<String>.empty(); // Ne rien suggérer pour moins de 3 lettres

    try {
      final response = await http.post(
        Uri.parse('http://172.16.5.123/inventaire/suggestions.php'), // ← Crée ce fichier
        headers: {'Accept': 'application/json'},
        body: {'query': code},
      );

      if (response.statusCode == 200) {
        final List<dynamic> suggestions = jsonDecode(response.body);
        return suggestions.map((e) => e.toString());
      }
    } catch (_) {}

    return const Iterable<String>.empty();
  },
  onSelected: (String selection) {
    codesuiteController.text = selection;
    _fetchArticleData(selection); // Charge les autres infos
  },
  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      decoration: _inputDecoration('Code Article (auto)'),
    );
  },
),
                    const SizedBox(height: 20),
                    _textField('Référence Article', referenceController),
                    const SizedBox(height: 20),
                    _textField('Désignation',        designationController),
                    const SizedBox(height: 20),
                    _textField('Emplacement',        emplacementController),
                    const SizedBox(height: 20),
                    Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: _textField('Comptage 1', comptageControllers[0], isNumeric: true),
    ),
    IconButton(
      icon: Icon(showComptage2 ? Icons.expand_less : Icons.expand_more),
      tooltip: showComptage2 ? 'Masquer Comptage 2' : 'Ajouter Comptage 2',
      onPressed: () {
        setState(() {
          showComptage2 = !showComptage2;
        });
      },
    ),
  ],
),
if (showComptage2) ...[
  const SizedBox(height: 20),
  _textField('Comptage 2', comptageControllers[1], isNumeric: true),
],


                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _enregistrerStock,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
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

/* ============ Widgets utilitaires ============ */
  Widget _textField(String label, TextEditingController ctrl, {bool isNumeric = false}) => TextField(
        controller: ctrl,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: _inputDecoration(label),
      );

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

  Widget _infoRow(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 8),
          Text('$label : ', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: GoogleFonts.montserrat(color: Colors.green[800]))),
        ],
      );
}
