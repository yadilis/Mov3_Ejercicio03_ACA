import 'package:flutter/material.dart';

class Pantalla1screen extends StatefulWidget {
  const Pantalla1screen({super.key});

  @override
  State<Pantalla1screen> createState() => _Pantalla1screenState();
}

class _Pantalla1screenState extends State<Pantalla1screen> {
  List<String> materiasDisponibles = [];
  String? nombreEstudiante;
  Map<String, List<double>> materiasConNotas = {};

  void _agregarMateria() {
    final TextEditingController materiaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar nueva materia'),
        content: TextField(
          controller: materiaController,
          decoration: const InputDecoration(labelText: 'Nombre de la materia'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final materia = materiaController.text.trim();
              if (materia.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre de la materia no puede estar vacío')),
                );
                return;
              }
              if (materiasDisponibles.contains(materia)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La materia ya existe')),
                );
                return;
              }
              setState(() {
                materiasDisponibles.add(materia);
              });
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _ingresarNotas(String materia) {
    final TextEditingController estudianteController = TextEditingController(text: nombreEstudiante ?? '');
    final TextEditingController nota1Controller = TextEditingController();
    final TextEditingController nota2Controller = TextEditingController();
    final TextEditingController nota3Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ingresar notas para $materia'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: estudianteController,
                decoration: const InputDecoration(labelText: 'Nombre del estudiante'),
              ),
              TextField(
                controller: nota1Controller,
                decoration: const InputDecoration(labelText: 'Nota 1'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: nota2Controller,
                decoration: const InputDecoration(labelText: 'Nota 2'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: nota3Controller,
                decoration: const InputDecoration(labelText: 'Nota 3'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final estudiante = estudianteController.text.trim();
              final n1 = double.tryParse(nota1Controller.text.trim());
              final n2 = double.tryParse(nota2Controller.text.trim());
              final n3 = double.tryParse(nota3Controller.text.trim());

              if (estudiante.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingrese el nombre del estudiante')),
                );
                return;
              }

              if (n1 == null || n2 == null || n3 == null || n1 < 0 || n1 > 10 || n2 < 0 || n2 > 10 || n3 < 0 || n3 > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingrese notas válidas entre 0 y 10')),
                );
                return;
              }

              setState(() {
                nombreEstudiante = estudiante;
                materiasConNotas[materia] = [n1, n2, n3];
              });

              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  double _calcularPromedio(List<double> notas) {
    if (notas.isEmpty) return 0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso de Materias y Notas')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Materia'),
              onPressed: _agregarMateria,
            ),
            const SizedBox(height: 20),
            Text(
              nombreEstudiante == null ? 'No se ha ingresado estudiante' : 'Estudiante: $nombreEstudiante',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: materiasDisponibles.length,
                itemBuilder: (context, index) {
                  final materia = materiasDisponibles[index];
                  final notas = materiasConNotas[materia];
                  final promedio = (notas != null) ? _calcularPromedio(notas) : 0;

                  return ListTile(
                    title: Text(materia),
                    subtitle: notas == null
                        ? const Text('No hay notas ingresadas')
                        : Text('Notas: ${notas.map((n) => n.toStringAsFixed(1)).join(', ')}\nPromedio: ${promedio.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _ingresarNotas(materia),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
