import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/item_repository.dart';
import 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  final ItemRepository repository;
  ApiCubit(this.repository) : super(ApiInitial());

  Future<void> loadItems({int limit = 20, int offset = 0}) async {
    try {
      emit(ApiLoading());
      final items = await repository.fetchItemsFromApi(limit: limit, offset: offset);
      emit(ApiLoaded(items));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  Future<void> search(String q) async {
    try {
      emit(ApiLoading());
      final items = await repository.searchApi(q);
      emit(ApiLoaded(items));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  Future<void> fetchDetail(int id) async {
    try {
      emit(ApiLoading());
      final item = await repository.fetchDetail(id);
      emit(ApiLoaded([item]));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }
}
