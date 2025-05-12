import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SandboxApp());
}

class SandboxApp extends StatelessWidget {
  const SandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandbox App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue,
          onPrimary: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor:
            Colors.blue, // Color de la barra de navegación
        systemNavigationBarIconBrightness: Brightness.light, // Íconos claros
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandbox App')),
      body: Center(
        child: Text(
          'Página ${_currentIndex + 1}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción del botón flotante
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Botón Add'),
                  content: const Text('¡Has presionado el botón flotante!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.blue, // Color del BottomAppBar
        child: SizedBox(
          height: 90, // Ajusta la altura del BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                color: _currentIndex == 0 ? Colors.white : Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                color: _currentIndex == 1 ? Colors.white : Colors.grey,
              ),
            ],
          ),
        ),
      ),
      extendBody: true, // Extiende el cuerpo detrás del BottomAppBar
    );
  }
}
