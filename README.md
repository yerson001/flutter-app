# Flutter + BLoC + Google Sheets Integration

Este proyecto es una aplicación Flutter que implementa un CRUD conectado a una hoja de Google Sheets utilizando el patrón de arquitectura BLoC (Business Logic Component).

## Tecnologías usadas

* **Flutter**
* **BLoC** (flutter\_bloc)
* **Google Sheets API**
* **googleapis y googleapis\_auth**
* **Arquitectura en capas:** presentation, domain, data

---

## Estructura de Carpetas

```
lib/
├── main.dart
├── src/
│   ├── data/
│   │   └── repositories/
│   │       └── sheet_data_repository.dart
│   ├── domain/
│   │   └── repositories/
│   │       └── sheet_repository.dart
│   └── presentation/
│       └── pages/
│           └── home/
│               ├── bloc/
│               │   ├── home_bloc.dart
│               │   ├── home_event.dart
│               │   └── home_state.dart
│               └── home_page.dart
assets/
└── credentials.json
```

---

## main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplecitas/src/data/repositories/sheet_data_repository.dart';
import 'package:simplecitas/src/presentation/pages/home/bloc/home_bloc.dart';
import 'package:simplecitas/src/presentation/pages/home/bloc/home_event.dart';
import 'package:simplecitas/src/presentation/pages/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repository = SheetsDataRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => HomeBloc(repository)..add(LoadData()),
        child: HomePage(),
      ),
    );
  }
}
```

---

## Repositorio de Dominio - sheet\_repository.dart

```dart
abstract class SheetRepository {
  Future<List<List<Object?>>> fetchData();
  Future<void> addData(String title, String content);
  Future<void> deleteData(int rowIndex);
}
```

---

## Repositorio de Datos - sheet\_data\_repository.dart

```dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import '../../domain/repositories/sheet_repository.dart';

class SheetsDataRepository implements SheetRepository {
  final _spreadsheetId = 'TU_SPREADSHEET_ID';
  final _sheetName = 'Hoja1';
  final _scopes = [sheets.SheetsApi.spreadsheetsScope];

  Future<sheets.SheetsApi> _getSheetsApi() async {
    final credentials = json.decode(
      await rootBundle.loadString('assets/credentials.json'),
    );
    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    return sheets.SheetsApi(client);
  }

  @override
  Future<List<List<Object?>>> fetchData() async {
    final api = await _getSheetsApi();
    final response = await api.spreadsheets.values.get(
      _spreadsheetId,
      '$_sheetName!A2:B',
    );
    return response.values ?? [];
  }

  @override
  Future<void> addData(String title, String content) async {
    final api = await _getSheetsApi();
    await api.spreadsheets.values.append(
      sheets.ValueRange(values: [[title, content]]),
      _spreadsheetId,
      '$_sheetName!A:B',
      valueInputOption: 'RAW',
    );
  }

  @override
  Future<void> deleteData(int rowIndex) async {
    final api = await _getSheetsApi();
    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(requests: [
        sheets.Request(
          deleteDimension: sheets.DeleteDimensionRequest(
            range: sheets.DimensionRange(
              sheetId: 0,
              dimension: 'ROWS',
              startIndex: rowIndex,
              endIndex: rowIndex + 1,
            ),
          ),
        )
      ]),
      _spreadsheetId,
    );
  }
}
```

---

## Bloc - home\_event.dart

```dart
abstract class HomeEvent {}

class LoadData extends HomeEvent {}
class AddEntry extends HomeEvent {
  final String title;
  final String content;
  AddEntry(this.title, this.content);
}
class DeleteEntry extends HomeEvent {
  final int rowIndex;
  DeleteEntry(this.rowIndex);
}
```

## Bloc - home\_state.dart

```dart
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<List<Object?>> data;
  HomeLoaded(this.data);
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
```

## Bloc - home\_bloc.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../../domain/repositories/sheet_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SheetRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadData>((event, emit) async {
      emit(HomeLoading());
      try {
        final data = await repository.fetchData();
        emit(HomeLoaded(data));
      } catch (e) {
        emit(HomeError('Error al cargar datos'));
      }
    });

    on<AddEntry>((event, emit) async {
      try {
        await repository.addData(event.title, event.content);
        add(LoadData());
      } catch (_) {
        emit(HomeError('Error al agregar entrada'));
      }
    });

    on<DeleteEntry>((event, emit) async {
      try {
        await repository.deleteData(event.rowIndex);
        add(LoadData());
      } catch (_) {
        emit(HomeError('Error al eliminar entrada'));
      }
    });
  }
}
```

---

## Presentación - home\_page.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomePage extends StatelessWidget {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Contenido')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              context.read<HomeBloc>().add(AddEntry(
                    _titleController.text,
                    _contentController.text,
                  ));
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sheets CRUD')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            final data = state.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(data[index][0].toString()),
                  subtitle: Text(data[index][1].toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<HomeBloc>().add(DeleteEntry(index + 1));
                    },
                  ),
                );
              },
            );
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## Notas Finales

* Asegúrate de agregar `credentials.json` en `assets/` y definirlo en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/credentials.json
```

* Agrega las dependencias necesarias:

```yaml
dependencies:
  flutter:
    sdk: flutter
  googleapis: any
  googleapis_auth: any
  flutter_bloc: ^8.1.0
```


Presentation Script: Explaining Clean Architecture and BLoC in Flutter
1. Introduction
Start with a brief overview:
"Today, we’ll explore how to build a Flutter application using Clean Architecture and the BLoC pattern. We’ll use this project, Simple Citas, as an example to understand how to structure a scalable and maintainable Flutter app."
"By the end of this session, you’ll understand the key principles of Clean Architecture, how to implement the BLoC pattern, and how these concepts work together in Flutter."
2. What is Clean Architecture?
Explain the concept:

"Clean Architecture is a software design philosophy that emphasizes separation of concerns. It divides the application into layers, each with a specific responsibility."
"The goal is to make the codebase modular, testable, and easy to maintain."
Show the layers:

"In Clean Architecture, we typically have three main layers:
Presentation Layer: Handles the UI and user interactions.
Domain Layer: Contains the business logic and use cases.
Data Layer: Manages data sources like APIs or databases."
3. What is the BLoC Pattern?
Define BLoC:

"BLoC stands for Business Logic Component. It’s a design pattern in Flutter that separates business logic from the UI."
"It uses streams to handle state changes and events, making the app reactive and predictable."
Why use BLoC?

"BLoC helps us:
Keep the UI code clean and focused on rendering.
Centralize business logic for better testability.
Manage state efficiently in Flutter apps."
4. Project Overview
Introduce the project:

"Our project, Simple Citas, is a Flutter app that uses Clean Architecture and BLoC to manage appointments. It includes features like fetching data from Google Sheets, displaying it in a list, and managing themes dynamically."
Show the folder structure:

"Let’s look at the folder structure:
app_theme.dart: Defines the app’s light and dark themes.
data: Contains repositories and data sources.
presentation: Contains UI components like pages and widgets.
home: Includes the HomePage and its BLoC logic."
5. Code Walkthrough
a. Main Entry Point
Explain main.dart:
"The main.dart file is the entry point of the app. It initializes the app and sets up the theme and BLoC provider."
Highlight:
ValueNotifier for dynamic theme switching.
BlocProvider for injecting the HomeBloc.
b. Presentation Layer
Explain HomePage:
"The HomePage is the main screen of the app. It uses a BlocBuilder to listen to state changes from the HomeBloc and update the UI accordingly."
Show how the BottomAppBar and FloatingActionButton are implemented for navigation and actions.
c. BLoC Logic
Explain HomeBloc:
"The HomeBloc manages the state of the HomePage. It listens to events like LoadData and emits states like HomeLoading, HomeLoaded, or HomeError."
Highlight the use of streams for state management.
d. Data Layer
Explain SheetDataRepositoryImpl:
"This repository handles fetching data from Google Sheets. It abstracts the data source, making it easy to replace or mock during testing."
e. Theme Management
Explain app_theme.dart:
"The app_theme.dart file defines the light and dark themes for the app. It uses Flutter’s ThemeData to customize colors, typography, and other UI elements."
6. Demonstration
Run the app:
"Let’s run the app and see it in action."
Show:
The dynamic theme switching using the FloatingActionButton.
The BottomAppBar navigation.
How the app fetches and displays data from Google Sheets.
7. Benefits of Clean Architecture and BLoC
Summarize the advantages:
"Using Clean Architecture and BLoC in Flutter provides:
A modular and testable codebase.
Clear separation of concerns.
Scalability for larger projects."
8. Q&A
Encourage questions:
"Do you have any questions about Clean Architecture, BLoC, or this project?"
9. Conclusion
Wrap up:
"Today, we learned how to structure a Flutter app using Clean Architecture and BLoC. These principles help us build scalable, maintainable, and testable applications."
"I encourage you to explore these concepts further and try implementing them in your own projects."
Tips for Presentation
Use visuals:
Show diagrams of Clean Architecture layers and the BLoC flow (Events → BLoC → States).
Keep it interactive:
Ask students to identify layers or components in the code.
Provide resources:
Share links to documentation or tutorials on Clean Architecture and BLoC.
If you need more details or adjustments, let me know! 😊