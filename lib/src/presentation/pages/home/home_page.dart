import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_bloc.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_event.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_state.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode mode) onThemeChanged;

  const HomePage({super.key, required this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google CRUD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final currentTheme =
                  Theme.of(context).brightness == Brightness.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
              widget.onThemeChanged(currentTheme);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () => setState(() => _currentIndex = 0),
              color:
                  _currentIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            const SizedBox(width: 40), // espacio para el botón flotante
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => setState(() => _currentIndex = 1),
              color:
                  _currentIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => setState(() => _currentIndex = 2),
              color:
                  _currentIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  context.read<HomeBloc>().add(LoadData());
                },
                child: const Icon(Icons.summarize),
              )
              : null,
    );
  }

  Widget _getBody() {
    if (_currentIndex == 0) {
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final appointment = state.data[index];
                return ListTile(
                  title: Text('${appointment.nombre} ${appointment.apellido}'),
                  subtitle: Text(
                    'DNI: ${appointment.dni} - Hora: ${appointment.horaInicio}',
                  ),
                  trailing: Text('S/ ${appointment.costo.toStringAsFixed(2)}'),
                );
              },
            );
          } else if (state is HomeError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Presiona para cargar'));
        },
      );
    } else if (_currentIndex == 1) {
      return const Center(child: Text('Página de Configuración'));
    } else if (_currentIndex == 2) {
      return const Center(child: Text('Página de Información'));
    }
    return const SizedBox.shrink();
  }
}
