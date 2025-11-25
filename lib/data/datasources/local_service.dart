import 'package:hive/hive.dart';
import '../models/item_model.dart';

class LocalService {
  static const String boxName = 'prefs_box';

  Future<void> init() async {
    // Inicialización en main: Hive.initFlutter()
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ItemModelAdapter());
    }
    await Hive.openBox<ItemModel>(boxName);
  }

  Box<ItemModel> _box() => Hive.box<ItemModel>(boxName);

  List<ItemModel> getAll() => _box().values.toList();

  Future<void> add(ItemModel item) async {
    await _box().put(item.id, item);
  }

  Future<void> update(ItemModel item) async {
    await item.save();
  }

  Future<void> delete(int id) async {
    await _box().delete(id);
  }

  ItemModel? getById(int id) => _box().get(id);
}
