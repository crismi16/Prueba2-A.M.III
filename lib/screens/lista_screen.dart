import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaLibros extends StatefulWidget {
  const ListaLibros({super.key});

  @override
  _ListaLibrosState createState() => _ListaLibrosState();
}

class _ListaLibrosState extends State<ListaLibros> {
  List libros = [];

  @override
  void initState() {
    super.initState();
    fetchLibros();
  }

  Future<void> fetchLibros() async {
    final response = await http.get(Uri.parse('https://jritsqmet.github.io/web-api/libros.json'));

    if (response.statusCode == 200) {
      setState(() {
        libros = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load libros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Libros',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: libros.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    libros[index]['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    libros[index]['genre'],
                    style: TextStyle(color: Colors.white70),
                  ),
                  leading: Image.network(libros[index]['image']),
                  onTap: () {
                    _showBookDetails(context, libros[index]);
                  },
                );
              },
            ),
      backgroundColor: Colors.black,
    );
  }

  void _showBookDetails(BuildContext context, dynamic libro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(libro['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Género: ${libro['genre']}'),
              SizedBox(height: 10),
              Text('Autor: ${libro['author']}'),
              SizedBox(height: 10),
              Text('Descripción: ${libro['description']}'),
            ],
          ),
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
