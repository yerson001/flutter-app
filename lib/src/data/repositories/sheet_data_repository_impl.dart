import 'package:http/http.dart' as http;
import 'package:simplecitas/src/domain/models/appointment_model.dart';
import 'dart:convert';

import 'package:simplecitas/src/domain/repositories/data_repository.dart';

class SheetDataRepositoryImpl implements DataRepository {
  final String sheetId = '1aQBsct8h7rRAdWATJUqS3FrESAymnRG3xo2SCWu_m8E';
  final String sheetId2 = '13Ut20EpFYGeSBLkH5a9qvkXSuEb9C564_oulkGDqytY';
  final String sheetName = 'Hoja2';

  @override
  Future<List<AppointmentModel>> showData() async {
    // TODO: implement showData
    final url =
        'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?tqx=out:csv&sheet=$sheetName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final lines = const LineSplitter().convert(response.body);

      final dateLines = lines.skip(1);

      final appointments =
          dateLines.map((line) {
            final columns = line.split(',');
            return AppointmentModel.fromList(columns);
          }).toList();
      return appointments;
    } else {
      throw Exception('Error get Data From sheet');
    }
  }
}
