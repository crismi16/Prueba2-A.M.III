import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecomendacionesScreen extends StatelessWidget {
  const RecomendacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recomendaciones',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: const RecommendationForm(),
      backgroundColor: Colors.black, // Fondo negro
    );
  }
}

class RecommendationForm extends StatefulWidget {
  const RecommendationForm({super.key});

  @override
  _RecommendationFormState createState() => _RecommendationFormState();
}

class _RecommendationFormState extends State<RecommendationForm> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController bookController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Agregar Nueva Recomendación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                  controller: idController,
                  label: 'ID de la Recomendación',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El ID no puede estar vacío.';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildInputField(
                  controller: bookController,
                  label: 'Nombre del Libro',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre del libro no puede estar vacío.';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              _buildInputField(
                  controller: genreController,
                  label: 'Género',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El género no puede estar vacío.';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              _saveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF27C4D9)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await _saveRecommendation(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF27C4D9),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Guardar',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _saveRecommendation(BuildContext context) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("recomendaciones").push();
      await ref.set({
        "id": idController.text,
        "libro": bookController.text,
        "genero": genreController.text,
      });
      _showAlertDialog(context, 'Éxito', 'Recomendación guardada con éxito.');
      _clearFields();
      FocusScope.of(context).unfocus();
    } catch (e) {
      _showAlertDialog(context, 'Error', 'Error al guardar la recomendación.');
      debugPrint(e.toString());
    }
  }

  void _clearFields() {
    idController.clear();
    bookController.clear();
    genreController.clear();
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
