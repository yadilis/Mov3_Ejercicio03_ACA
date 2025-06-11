import 'package:flutter/material.dart';

// === MODELOS ===
class Materia {
  String nombre;
  List<double> notas = [];

  Materia(this.nombre);

  void agregarNota(double nota) {
    notas.add(nota);
  }

  double calcularPromedio() {
    if (notas.isEmpty) return 0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  String get info {
    String notasStr = notas.map((n) => n.toStringAsFixed(1)).join(', ');
    return 'Materia: $nombre\nNotas: [$notasStr]\nPromedio: ${calcularPromedio().toStringAsFixed(2)}';
  }
}

class Estudiante {
  String nombre;
  List<Materia> materias = [];

  Estudiante(this.nombre);

  void agregarMateria(Materia materia) {
    materias.add(materia);
  }

  double promedioGeneral() {
    if (materias.isEmpty) return 0;
    double total = materias.fold(0, (suma, m) => suma + m.calcularPromedio());
    return total / materias.length;
  }

  List<String> obtenerInformacion() {
    return materias.map((m) => m.info).toList()
      ..add('Promedio General: ${promedioGeneral().toStringAsFixed(2)}');
  }
}

// === PANTALLA PRINCIPAL ===
class Pantalla1Screen extends StatefulWidget {
  const Pantalla1Screen({super.key});

  @override
  State<Pantalla1Screen> createState() => _Pantalla1ScreenState();
}

class _Pantalla1ScreenState extends State<Pantalla1Screen> {
  final Estudiante estudiante = Estudiante('Carlos');

  void _mostrarDialogoAgregarMateria() {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController nota1Controller = TextEditingController();
    final TextEditingController nota2Controller = TextEditingController();
    final TextEditingController nota3Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar Materia'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la materia'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nota1Controller,
                decoration: const InputDecoration(labelText: 'Nota 1'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nota2Controller,
                decoration: const InputDecoration(labelText: 'Nota 2'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nota3Controller,
                decoration: const InputDecoration(labelText: 'Nota 3'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              final nombre = nombreController.text.trim();
              final nota1 = double.tryParse(nota1Controller.text.trim());
              final nota2 = double.tryParse(nota2Controller.text.trim());
              final nota3 = double.tryParse(nota3Controller.text.trim());

              bool notasValidas = [nota1, nota2, nota3].every((n) => n != null && n >= 0 && n <= 10);

              if (nombre.isNotEmpty && notasValidas) {
                final materia = Materia(nombre);
                materia.agregarNota(nota1!);
                materia.agregarNota(nota2!);
                materia.agregarNota(nota3!);

                setState(() {
                  estudiante.agregarMateria(materia);
                });

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor ingresa un nombre y notas válidas entre 0 y 10.')),
                );
              }
            },
            child: const Text('Agregar'),
          ),
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus(); 
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = estudiante.obtenerInformacion();

    return Scaffold(
      appBar: AppBar(title: const Text('Estudiante - Materias')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: _mostrarDialogoAgregarMateria,
              child: const Text('Agregar Materia'),
            ),
          ),
          Expanded(
            child: info.isEmpty
                ? const Center(child: Text('No hay materias aún.'))
                : ListView.builder(
                    itemCount: info.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(info[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Pantalla1Screen(),
  ));
}
