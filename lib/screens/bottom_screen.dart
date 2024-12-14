import 'package:flutter/material.dart';
import 'recomendaciones_screen.dart';
import 'lista_screen.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    RecomendacionesScreen(),
    ListaLibros(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sistema de Recomendaciones de Libros',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recomendaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libros',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF27C4D9),
        backgroundColor: Colors.black, // Fondo negro
        unselectedItemColor: Colors.white, // Color de los íconos no seleccionados
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.black,
    );
  }
}
