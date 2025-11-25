import '../../../data/models/item_model.dart';

abstract class PrefState {}
class PrefInitial extends PrefState {}
class PrefLoading extends PrefState {}
class PrefLoaded extends PrefState {
  final List<ItemModel> items;
  PrefLoaded(this.items);
}
class PrefError extends PrefState {
  final String message;
  PrefError(this.message);
}
