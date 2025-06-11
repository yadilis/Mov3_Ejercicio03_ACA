import 'package:flutter/material.dart';

// Clase Libro
class Libro {
  String titulo;
  String autor;
  int anioPublicacion;
  int cantidadDisponible;

  Libro({
    required this.titulo,
    required this.autor,
    required this.anioPublicacion,
    required this.cantidadDisponible,
  });

  String get info {
    return 'Título: $titulo\nAutor: $autor\nAño: $anioPublicacion\nCantidad Disponible: $cantidadDisponible';
  }
}

// Clase Biblioteca para manejar lista de libros
class Biblioteca {
  List<Libro> libros = [];

  void agregarLibro(Libro libro) {
    libros.add(libro);
  }

  List<Libro> buscarPorTitulo(String titulo) {
    return libros
        .where((libro) =>
            libro.titulo.toLowerCase().contains(titulo.toLowerCase().trim()))
        .toList();
  }

  List<Libro> obtenerTodos() {
    return libros;
  }
}

// Pantalla 2
class Pantalla2Screen extends StatefulWidget {
  const Pantalla2Screen({super.key});

  @override
  State<Pantalla2Screen> createState() => _Pantalla2ScreenState();
}

class _Pantalla2ScreenState extends State<Pantalla2Screen> {
  final Biblioteca biblioteca = Biblioteca();

  final TextEditingController busquedaController = TextEditingController();
  List<Libro> librosFiltrados = [];

  @override
  void initState() {
    super.initState();
    librosFiltrados = biblioteca.obtenerTodos();
  }

  void _mostrarDialogoAgregarLibro() {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController autorController = TextEditingController();
    final TextEditingController anioController = TextEditingController();
    final TextEditingController cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar Libro'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
              TextField(
                controller: anioController,
                decoration: const InputDecoration(labelText: 'Año de publicación'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad disponible'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final titulo = tituloController.text.trim();
              final autor = autorController.text.trim();
              final anio = int.tryParse(anioController.text.trim());
              final cantidad = int.tryParse(cantidadController.text.trim());

              if (titulo.isEmpty || autor.isEmpty || anio == null || cantidad == null || anio <= 0 || cantidad < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, ingresa datos válidos.')),
                );
                return;
              }

              final libro = Libro(
                titulo: titulo,
                autor: autor,
                anioPublicacion: anio,
                cantidadDisponible: cantidad,
              );

              setState(() {
                biblioteca.agregarLibro(libro);
                librosFiltrados = biblioteca.obtenerTodos();
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

  void _buscarLibros() {
    final busqueda = busquedaController.text;
    setState(() {
      if (busqueda.isEmpty) {
        librosFiltrados = biblioteca.obtenerTodos();
      } else {
        librosFiltrados = biblioteca.buscarPorTitulo(busqueda);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca - Libros')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: _mostrarDialogoAgregarLibro,
              child: const Text('Agregar Libro'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: busquedaController,
              decoration: InputDecoration(
                labelText: 'Buscar por título',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarLibros,
                ),
              ),
              onSubmitted: (_) => _buscarLibros(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: librosFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron libros.'))
                : ListView.builder(
                    itemCount: librosFiltrados.length,
                    itemBuilder: (context, index) {
                      final libro = librosFiltrados[index];
                      return ListTile(
                        title: Text(libro.titulo),
                        subtitle: Text(libro.info),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
