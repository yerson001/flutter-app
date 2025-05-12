/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:simplecitas/src/presentation/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  final double _width = 45;
  final double _margin = 2;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });

    _scrollController = ScrollController();
    _selectedDate = DateTime.now();
    _firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
      // Calcular el inicio de la semana actual (domingo)
      DateTime startOfWeek = _selectedDate.subtract(
        Duration(days: _selectedDate.weekday % 7),
      );
      int daysOffset = startOfWeek.difference(_firstDayOfMonth).inDays;

      // Calcular el desplazamiento para centrar la semana actual
      double scrollOffset = daysOffset * (_width + _margin);
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _buildTodayView(),
    );
  }

  Widget _buildAppBarTitle() {
    if (_selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day) {
      return const Text('Hoy');
    } else {
      return Text(DateFormat('dd MMM yyyy').format(_selectedDate));
    }
  }

  Widget _buildTodayView() {
    return SizedBox(
      height: 75, // Ajusta la altura según lo que necesites
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(children: _buildDateWidgets()),
      ),
    );
  }

  List<Widget> _buildDateWidgets() {
    List<Widget> dateWidgets = [];

    // Generar todos los días del mes
    for (int i = 0; i < _lastDayOfMonth.day; i++) {
      DateTime currentDate = _firstDayOfMonth.add(Duration(days: i));
      dateWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
            _scrollToSelectedDate();
          },
          child: Container(
            width: _width,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: _margin),
            decoration: BoxDecoration(
              color:
                  currentDate.day == _selectedDate.day
                      ? AppColors.ktextIconPrimary
                      : AppColors.kGray, // Otros días
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Nombre del día
                Positioned(
                  top: 5,
                  child: Text(
                    toBeginningOfSentenceCase(
                      DateFormat('EEE', 'es_ES').format(currentDate),
                    )!,
                    style: const TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ),
                // Contenedor del número del día
                Positioned(
                  bottom: 0, // Sobresale hacia abajo
                  child: Container(
                    width: _width, // Ajustar el ancho del contenedor
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        48,
                        48,
                        48,
                      ), // Fondo gris
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10), // Menos redondeado arriba
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(15), // Más redondeado abajo
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      "${currentDate.day}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return dateWidgets;
  }
}
*/
