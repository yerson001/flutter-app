import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplecitas/src/app_theme.dart';
import 'package:simplecitas/src/data/repositories/sheet_data_repository_impl.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_bloc.dart';
import 'package:simplecitas/src/presentation/pages/home/home_page.dart';

void main() {
  final repository = SheetDataRepositoryImpl();
  runApp(MyApp(repository));
}

class MyApp extends StatelessWidget {
  final SheetDataRepositoryImpl repositoryImpl;
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  MyApp(this.repositoryImpl);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: "Simple Citas",
          theme: AppThemes.greenFinanceTheme,
          darkTheme: AppThemes.greenFinanceDarkTheme,
          themeMode: currentTheme,
          home: BlocProvider(
            create: (_) => HomeBloc(repositoryImpl),
            child: HomePage(
              onThemeChanged: (ThemeMode mode) {
                themeNotifier.value = mode; // Cambia el tema dinámicamente
              },
            ),
          ),
        );
      },
    );
  }
}
