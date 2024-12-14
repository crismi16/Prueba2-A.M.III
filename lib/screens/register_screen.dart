import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Crea una cuenta para comenzar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _emailInput(),
                SizedBox(height: 20),
                _passwordInput(),
                SizedBox(height: 20),
                _registerButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailInput() {
    return _buildInputField(
      controller: emailController,
      label: 'Correo electrónico',
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordInput() {
    return _buildInputField(
      controller: passwordController,
      label: 'Contraseña',
      obscureText: true,
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _registerUser(context, emailController.text, passwordController.text);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF27C4D9),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Registrarse',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF27C4D9)),
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context, String email, String password) async {
    try {
      // Firebase Authentication
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Opcional: Verificar que la cuenta fue creada
      print("Usuario registrado con UID: ${credential.user?.uid}");

      _showAlertDialog(context, 'Éxito', 'Usuario registrado con éxito.');
    } catch (e) {
      _showAlertDialog(context, 'Error', 'Hubo un error al registrar el usuario. ${e.toString()}');
      print(e);
    }
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
              child: Text('OK'),
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
