import '../datasources/api_service.dart';
import '../datasources/local_service.dart';
import '../models/item_model.dart';

class ItemRepository {
  final ApiService api;
  final LocalService local;

  ItemRepository({required this.api, required this.local});

  Future<List<ItemModel>> fetchItemsFromApi({int limit = 20, int offset = 0}) {
    return api.fetchItems(limit: limit, offset: offset);
  }

  Future<List<ItemModel>> searchApi(String q) => api.searchItems(q);

  Future<ItemModel> fetchDetail(int id) => api.fetchDetail(id);

  // Local:
  List<ItemModel> getLocalItems() => local.getAll();
  Future<void> addLocal(ItemModel item) => local.add(item);
  Future<void> updateLocal(ItemModel item) => local.update(item);
  Future<void> deleteLocal(int id) => local.delete(id);
  ItemModel? getLocalById(int id) => local.getById(id);
}
