import 'package:bloc/bloc.dart';
import 'package:simplecitas/src/data/repositories/sheet_data_repository_impl.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_event.dart';
import 'package:simplecitas/src/presentation/pages/home/block/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SheetDataRepositoryImpl repositoryImpl;

  HomeBloc(this.repositoryImpl) : super(HomeInitial()) {
    on<LoadData>((event, emit) async {
      emit(HomeLoading());
      try {
        final data =
            await repositoryImpl.showData(); // asegúrate de usar repositoryImpl
        emit(HomeLoaded(data));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
