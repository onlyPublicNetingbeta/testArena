import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';
import 'preference_state.dart';

class PreferenceCubit extends Cubit<PrefState> {
  final ItemRepository repository;
  PreferenceCubit(this.repository) : super(PrefInitial());

  Future<void> loadPrefs() async {
    try {
      emit(PrefLoading());
      final items = repository.getLocalItems();
      emit(PrefLoaded(items));
    } catch (e) {
      emit(PrefError(e.toString()));
    }
  }

  Future<void> addPref(ItemModel item) async {
    try {
      emit(PrefLoading());
      await repository.addLocal(item);
      final items = repository.getLocalItems();
      emit(PrefLoaded(items));
    } catch (e) {
      emit(PrefError(e.toString()));
    }
  }

  Future<void> updatePref(ItemModel item) async {
    try {
      emit(PrefLoading());
      await repository.updateLocal(item);
      final items = repository.getLocalItems();
      emit(PrefLoaded(items));
    } catch (e) {
      emit(PrefError(e.toString()));
    }
  }

  Future<void> deletePref(int id) async {
    try {
      emit(PrefLoading());
      await repository.deleteLocal(id);
      repository.getLocalItems();
      emit(PrefLoaded(repository.getLocalItems()));
    } catch (e) {
      emit(PrefError(e.toString()));
    }
  }
}
