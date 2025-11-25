import 'package:hive/hive.dart';
part 'item_model.g.dart';

@HiveType(typeId: 0)
class ItemModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String apiName;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String customName; // nombre personalizado guardado localmente

  ItemModel({
    required this.id,
    required this.apiName,
    required this.imageUrl,
    required this.customName,
  });

  // from JSON (PokeAPI example)
  factory ItemModel.fromApiJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;
    final image = (json['sprites']?['front_default'] as String?) ?? '';
    return ItemModel(
      id: id,
      apiName: name,
      imageUrl: image,
      customName: name, // por defecto mismo nombre
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': apiName,
      'image': imageUrl,
      'customName': customName,
    };
  }

  ItemModel copyWith({String? customName}) {
    return ItemModel(
      id: id,
      apiName: apiName,
      imageUrl: imageUrl,
      customName: customName ?? this.customName,
    );
  }
}
