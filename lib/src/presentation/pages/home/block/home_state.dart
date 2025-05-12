import 'package:simplecitas/src/domain/models/appointment_model.dart';

abstract class HomeState {}

//lo que va existir en la pantalla en ese momento
class HomeInitial extends HomeState {
  HomeInitial() {
    print('INCIAL STATE');
  }
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<AppointmentModel> data;
  HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
