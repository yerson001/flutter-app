import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/date_symbol_data_file.dart';
import 'package:simplecitas/src/presentation/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

const _spreadsheetId = '1aQBsct8h7rRAdWATJUqS3FrESAymnRG3xo2SCWu_m8E';
const _sheetName = 'Hoja1'; // Cambia esto si tu hoja tiene otro nombre
const _scopes = [sheets.SheetsApi.spreadsheetsScope];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD con Google Sheets',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.kBackgroundColor,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.kButtonPrimary,
          onPrimary: Colors.white,
          secondary: AppColors.kButtonSecondary,
          onSecondary: Colors.white,
          background: AppColors.kBackgroundColor,
          onBackground: AppColors.kLightOnGray,
          surface: AppColors.kGray,
          onSurface: AppColors.kLightOnGray,
          error: Colors.red,
          onError: Colors.white,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.kDarkGray, // Mismo color que el fondo
          elevation: 0, // Eliminar sombra del AppBar
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // Color de los íconos
          titleTextStyle: const TextStyle(
            color: Colors.white, // Color del texto del título
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Object?>> _data = [];
  List<String> _headers = [];
  String _searchQuery = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<List<Object?>> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _data;
    }
    return _data.where((row) {
      return row.any(
        (cell) =>
            cell.toString().toLowerCase().contains(_searchQuery.toLowerCase()),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<sheets.SheetsApi> _getSheetsApi() async {
    final credentials = json.decode(
      await rootBundle.loadString('assets/credentials.json'),
    );
    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    return sheets.SheetsApi(client);
  }

  Future<void> _fetchData() async {
    try {
      final sheetsApi = await _getSheetsApi();
      final response = await sheetsApi.spreadsheets.values.get(
        _spreadsheetId,
        '$_sheetName!A1:B', // Rango de celdas
      );

      setState(() {
        // Omite la primera fila (encabezados)
        _data = response.values?.skip(1).toList() ?? [];
      });
    } catch (e) {
      debugPrint('Error al obtener datos: $e');
    }
  }

  Future<void> _addData(String title, String content) async {
    try {
      final sheetsApi = await _getSheetsApi();
      await sheetsApi.spreadsheets.values.append(
        sheets.ValueRange(
          values: [
            [title, content],
          ],
        ),
        _spreadsheetId,
        '$_sheetName!A:B',
        valueInputOption: 'RAW',
      );
      _fetchData(); // Actualiza los datos después de agregar
    } catch (e) {
      debugPrint('Error al agregar datos: $e');
    }
  }

  Future<void> _deleteData(int rowIndex) async {
    try {
      final sheetsApi = await _getSheetsApi();
      await sheetsApi.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(
          requests: [
            sheets.Request(
              deleteDimension: sheets.DeleteDimensionRequest(
                range: sheets.DimensionRange(
                  sheetId: 0, // Cambia esto si tu hoja tiene un ID diferente
                  dimension: 'ROWS',
                  startIndex: rowIndex,
                  endIndex: rowIndex + 1,
                ),
              ),
            ),
          ],
        ),
        _spreadsheetId,
      );
      _fetchData(); // Actualiza los datos después de eliminar
    } catch (e) {
      debugPrint('Error al eliminar datos: $e');
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Datos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Contenido'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _addData(_titleController.text, _contentController.text);
                _titleController.clear();
                _contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD con Google Sheets'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Buscar...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body:
          _filteredData.isEmpty
              ? const Center(child: Text('No se encontraron resultados'))
              : ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  final row = _filteredData[index];
                  return ListTile(
                    title: Text(row[0].toString()),
                    subtitle: Text(row[1].toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteData(index + 1),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
