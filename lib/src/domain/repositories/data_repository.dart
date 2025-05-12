//El dominio Inicio definimos que vamos hacer
// no el como sino lo que se va hacer
// en este caso mostrar losdatos que vinen desde googlesheet
import 'package:simplecitas/src/domain/models/appointment_model.dart';

abstract class DataRepository {
  Future<List<AppointmentModel>> showData();
}
