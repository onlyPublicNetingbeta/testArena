import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  // Ejemplo: obtener lista de pokemons (paginado simple)
  Future<List<ItemModel>> fetchItems({int limit = 20, int offset = 0}) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
    final res = await client.get(url);
    if (res.statusCode != 200) throw Exception('API error ${res.statusCode}');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>;
    // Cada result tiene name y url => se debe obtener detalle para imagen e id
    final items = <ItemModel>[];
    for (final r in results) {
      final detailRes = await client.get(Uri.parse(r['url']));
      if (detailRes.statusCode != 200) continue;
      final detail = jsonDecode(detailRes.body) as Map<String, dynamic>;
      items.add(ItemModel.fromApiJson(detail));
    }
    return items;
  }

  // Búsqueda por nombre (tiempo real)
  Future<List<ItemModel>> searchItems(String query) async {
    if (query.trim().isEmpty) return [];
    // PokeAPI no tiene endpoint search por nombre partial; aquí intentamos 1 resultado
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$query');
    final res = await client.get(url);
    if (res.statusCode == 200) {
      final detail = jsonDecode(res.body) as Map<String, dynamic>;
      return [ItemModel.fromApiJson(detail)];
    } else {
      return [];
    }
  }

  // Obtener detalle por id
  Future<ItemModel> fetchDetail(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
    final res = await client.get(url);
    if (res.statusCode != 200) throw Exception('Not found');
    final detail = jsonDecode(res.body) as Map<String, dynamic>;
    return ItemModel.fromApiJson(detail);
  }
}
