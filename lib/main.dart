import 'package:flutter/material.dart';
import 'data/base_datos.dart';
import 'screens/tareas_page.dart';

void main() {
  runApp(GestorTareasApp(baseDatos: BaseDatos()));
}

/// Punto de entrada de la aplicación.
/// Recibe la base de datos desde main() para que las pruebas puedan
/// pasarle una base en memoria.
class GestorTareasApp extends StatelessWidget {
  const GestorTareasApp({super.key, required this.baseDatos});

  final BaseDatos baseDatos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TareasPage(baseDatos: baseDatos),
    );
  }
}
