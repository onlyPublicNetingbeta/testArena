
import '../../../data/models/item_model.dart';

abstract class ApiState {}
class ApiInitial extends ApiState {}
class ApiLoading extends ApiState {}
class ApiLoaded extends ApiState {
  final List<ItemModel> items;
  ApiLoaded(this.items);
}
class ApiError extends ApiState {
  final String message;
  ApiError(this.message);
}
