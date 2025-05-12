import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Prueba de widget predeterminada', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Text('Hola, mundo!'))),
    );

    expect(find.text('Hola, mundo!'), findsOneWidget);
  });
}
